# Implementation Notes

## Design
The application follows a simple flow: validate input, lock the data, apply the
change, log the result. Business rules live in stored procedures and functions, so
the database enforces them regardless of which client calls it.

## Records
- `process_transaction` uses a user-defined record (`t_txn_rec`) to group the
  incoming account, type and amount, and a `%ROWTYPE` record to hold the full
  account row fetched with `SELECT ... FOR UPDATE`.
- `apply_monthly_interest` uses a record holding account_id and balance.

## Collections
`apply_monthly_interest` defines a nested table of records. All active savings
accounts are loaded into it with one `BULK COLLECT`, then processed from memory.

## Cursors
- **Implicit:** after each `UPDATE` in `process_transaction`, `SQL%NOTFOUND` and
  `SQL%ROWCOUNT` confirm that exactly one row changed.
- **Explicit:** `apply_monthly_interest` uses `OPEN`, `FETCH ... BULK COLLECT` and
  `CLOSE` on a declared cursor.

## Bulk Processing and Performance
Row-by-row processing switches between the PL/SQL engine and the SQL engine once
per row (a context switch). For 10,000 accounts that means 10,000 switches.
`BULK COLLECT` fetches all rows in one switch, and `FORALL` sends all updates in
one switch, which is significantly faster for large volumes.

`FORALL ... SAVE EXCEPTIONS` also keeps going when individual rows fail. Failed
rows are reported through `SQL%BULK_EXCEPTIONS` (index and error code), and the
rows that succeeded are kept. Test case 10 shows this: a negative rate violates
the `balance >= 0` check on two accounts, while the zero-balance account succeeds.

Other performance choices:
- Indexes on the foreign keys (`customer_id`, `account_id`) speed up joins and lookups.
- `SELECT ... FOR UPDATE` locks the account row, preventing two transactions from
  changing the same balance at once.
- Bulk work is committed once, not once per row.

## Exception Handling
| Exception | Where | Handling |
|---|---|---|
| `NO_DATA_FOUND` | procedure and functions | Clear message, no silent failure |
| `TOO_MANY_ROWS` | `get_savings_account_id` | Shown with a customer that has two savings accounts |
| User-defined (`e_insufficient_funds`, `e_invalid_type`) | `process_transaction` | Rolls back, logs FAILED transactions |
| `RAISE_APPLICATION_ERROR` | all objects | Codes -20001 to -20023 with meaningful text |
| Bulk errors (-24381) | `apply_monthly_interest` | Per-row report, partial success kept |

Every `WHEN OTHERS` handler first re-raises our own -20xxx errors unchanged, then
wraps anything unexpected with its original `SQLERRM`, so errors are never hidden.

## Testing
- `test_success_cases.sql`: balance query, deposit, monthly interest, total balance,
  and data verification.
- `test_error_cases.sql`: ten failure cases covering every exception type.
- Screenshots of each run are in `screenshots/`.
  

No transfer between accounts yet (no destination account column).
