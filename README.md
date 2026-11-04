# Banking Transactions System (Oracle PL/SQL)

## Group Members
| Name | Student ID |
|------|------------|
|Ishimwe Florence| 20251SEN040 |
| Igiraneza Bernice Gentille | 27708 |

## Application Description
A banking application in Oracle PL/SQL that manages customers, accounts
and transactions. Deposits, withdrawals and monthly interest are handled
by stored procedures and functions, and failed transactions are logged
with the reason.

## Requirements
- Store customers, accounts and a transaction audit trail
- Reject invalid data (negative balances, bad account type or status)
- Process deposits and withdrawals safely with clear error messages
- Apply interest to many accounts at once using bulk operations
- Log failed transactions with an error message

## Database Schema
- `bank_customers`: name, unique email, phone
- `bank_accounts`: belongs to a customer; SAVINGS/CHECKING; balance >= 0; ACTIVE/SUSPENDED/CLOSED
- `bank_transactions`: belongs to an account; DEPOSIT/WITHDRAWAL/TRANSFER; status and error_message

One customer has many accounts; one account has many transactions.

## PL/SQL Concepts Used
| Concept | Where |
|---|---|
| User-defined record | `apply_monthly_interest` |
| `%ROWTYPE` | `<procedure name>` |
| Collection (nested table of records) | `apply_monthly_interest` |
| Implicit cursors, `SQL%ROWCOUNT/FOUND/NOTFOUND` | `purge_failed_transactions` |
| Explicit cursor (`OPEN/FETCH/CLOSE`) | `apply_monthly_interest` |
| `BULK COLLECT`, `FORALL ... SAVE EXCEPTIONS` | `apply_monthly_interest` |
| Predefined exceptions | `get_account_balance`, `process_transaction` |
| User-defined exceptions, `RAISE_APPLICATION_ERROR` | `process_transaction` |

## Procedures and Functions
- `process_transaction(account, type, amount)`: deposit or withdrawal, logs success or failure
- `apply_monthly_interest(rate)`: bulk interest on active savings accounts
- `purge_failed_transactions(days)`: deletes old failed records
- `get_account_balance(account)`: returns a balance
- `get_customer_total_balance(customer)`: sums a customer's active accounts

## How to Run
1. `00_schema/01_create_tables.sql`
2. `00_schema/02_insert_sample_data.sql`
3. Compile everything in `01_procedures/`
4. Compile everything in `02_functions/`
5. Run `03_tests/test_success_cases.sql`, then `test_error_cases.sql`
6. Compare with `screenshots/`

## Contributions
- Igiraneza Bernice Gentille: schema, process_transaction, success tests
- Ishimwe Florence:  bulk processing, functions, error tests, documentation
