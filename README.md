# PL/SQL Assignment IV: Records and Collections (Banking System)

## Group Members
| Name | Student ID |
|---|---|
| Ishimwe Florence | 20251SEN040 |
| Igiraneza Bernice Gentille | 27708 |

## Application Description
A Banking Transaction System built in Oracle PL/SQL. Customers own accounts, and
every deposit, withdrawal and monthly interest run is handled by stored procedures
and functions that validate input, protect data and report clear errors.

### Requirements
- Store customers, accounts and a transaction log with relationships and constraints
- Process deposits and withdrawals safely, logging both successes and failures
- Apply monthly interest to all active savings accounts using bulk processing
- Provide functions for balance queries
- Reject invalid requests with meaningful error messages

## Database Schema
| Table | Purpose |
|---|---|
| `bank_customers` | Customer details (unique email) |
| `bank_accounts` | Accounts per customer (type, balance >= 0, status) |
| `bank_transactions` | Audit log of every transaction (SUCCESS / FAILED) |

Relationships: one customer has many accounts; one account has many transactions.

## PL/SQL Objects
| Object | Type | Concepts shown |
|---|---|---|
| `process_transaction` | Procedure | User-defined record, `%ROWTYPE`, implicit cursor attributes, IN/OUT parameters, all exception types |
| `apply_monthly_interest` | Procedure | Nested table of records, explicit cursor, `BULK COLLECT`, `FORALL` with `SAVE EXCEPTIONS` |
| `get_account_balance` | Function | Parameters, local variable, `NO_DATA_FOUND`, `TOO_MANY_ROWS` |
| `get_customer_total_balance` | Function | Existence check, aggregate query, `RAISE_APPLICATION_ERROR` |
| `get_savings_account_id` | Function | Real `TOO_MANY_ROWS` demonstration |

## Repository Structure
```
plsql-assignment4-20251SEN040-27708/
├── README.md
├── 00_schema/        (01_create_tables.sql, 02_insert_sample_data.sql)
├── 01_procedures/    (process_transaction.sql, apply_monthly_interest.sql)
├── 02_functions/     (get_account_balance.sql, get_customer_total_balance.sql,
│                      get_savings_account_id.sql)
├── 03_tests/         (test_success_cases.sql, test_error_cases.sql)
├── screenshots/      (output of each test)
└── docs/             (IMPLEMENTATION_NOTES.md)
```

## How to Run
1. Run `00_schema/01_create_tables.sql`.
2. Run `00_schema/02_insert_sample_data.sql`.
3. Compile the stored procedures in `01_procedures/`.
4. Compile the stored functions in `02_functions/`.
5. Run `SET SERVEROUTPUT ON;`, then the test files in `03_tests/`
   (success cases first, error cases second; the last error test changes balances).
6. Verify your results against the screenshots in `screenshots/`.

## Error Codes
| Code | Meaning |
|---|---|
| ORA-20001 | Account not found or not active |
| ORA-20003 | Customer does not exist |
| ORA-20004 | Amount must be greater than zero |
| ORA-20005 | Insufficient funds |
| ORA-20006 | Invalid transaction type |
| ORA-20010 | Interest rate missing or above 100% |
| ORA-20023 | Several savings accounts found (`TOO_MANY_ROWS`) |

## Team Contributions
| Area | Ishimwe Florence (20251SEN040) |  Igiraneza Bernice Gentille (27708) |
|---|---|---|
| Design | Schema and relationships | Application scope and error codes |
| Schema and data | `01_create_tables.sql` | `02_insert_sample_data.sql` |
| Procedures | `process_transaction` | `apply_monthly_interest` |
| Functions | `get_account_balance`, `get_savings_account_id` | `get_customer_total_balance` |
| Testing | `test_success_cases.sql` | `test_error_cases.sql` |
| Screenshots | Success tests | Error tests |
| Documentation | `README.md` | `IMPLEMENTATION_NOTES.md` |
| Presentation | Records, collections, procedures | Cursors, bulk processing, exceptions |
