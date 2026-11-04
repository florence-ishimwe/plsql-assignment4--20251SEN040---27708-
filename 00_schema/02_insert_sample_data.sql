-- Insert Customers
INSERT INTO bank_customers (first_name, last_name, email, phone) 
VALUES ('Alice', 'Uwase', 'alice.uwase@email.com', '+250781112233');

INSERT INTO bank_customers (first_name, last_name, email, phone) 
VALUES ('Frank', 'Habimana', 'frank.habimana@email.com', '+250782223344');

INSERT INTO bank_customers (first_name, last_name, email, phone) 
VALUES ('Diane', 'Mutesi', 'diane.mutesi@email.com', '+250783334455');

-- Insert Accounts
INSERT INTO bank_accounts (customer_id, account_type, balance, status) 
VALUES (1, 'SAVINGS', 150000.00, 'ACTIVE');

INSERT INTO bank_accounts (customer_id, account_type, balance, status) 
VALUES (1, 'CHECKING', 45000.50, 'ACTIVE');

INSERT INTO bank_accounts (customer_id, account_type, balance, status) 
VALUES (2, 'SAVINGS', 320000.00, 'ACTIVE');

INSERT INTO bank_accounts (customer_id, account_type, balance, status) 
VALUES (3, 'CHECKING', 12000.00, 'ACTIVE');

INSERT INTO bank_accounts (customer_id, account_type, balance, status)
VALUES (3, 'SAVINGS', 0.00, 'ACTIVE');      -- zero balance

INSERT INTO bank_accounts (customer_id, account_type, balance, status)
VALUES (2, 'CHECKING', 5000.00, 'SUSPENDED'); -- blocked account

INSERT INTO bank_accounts (customer_id, account_type, balance, status)
VALUES (1, 'SAVINGS', 800.00, 'CLOSED');      -- closed account

-- Insert Transaction
INSERT INTO bank_transactions (account_id, transaction_type, amount, status)
VALUES (1, 'DEPOSIT', 20000, 'SUCCESS');
INSERT INTO bank_transactions (account_id, transaction_type, amount, status)
VALUES (1, 'WITHDRAWAL', 5000, 'SUCCESS');
INSERT INTO bank_transactions (account_id, transaction_type, amount, status)
VALUES (2, 'DEPOSIT', 10000, 'SUCCESS');
INSERT INTO bank_transactions (account_id, transaction_type, amount, status)
VALUES (3, 'WITHDRAWAL', 15000, 'SUCCESS');
INSERT INTO bank_transactions (account_id, transaction_type, amount, status)
VALUES (4, 'DEPOSIT', 3000, 'SUCCESS');
INSERT INTO bank_transactions (account_id, transaction_type, amount, status)
VALUES (2, 'WITHDRAWAL', 2500, 'SUCCESS');
INSERT INTO bank_transactions (account_id, transaction_type, amount, status)
VALUES (3, 'DEPOSIT', 50000, 'SUCCESS');
INSERT INTO bank_transactions (account_id, transaction_type, amount, status)
VALUES (4, 'WITHDRAWAL', 1000, 'SUCCESS');
INSERT INTO bank_transactions (account_id, transaction_type, amount, status,error_message)
VALUES (4, 'WITHDRAWAL', 99999, 'FAIL','Insufficient fund');
INSERT INTO bank_transactions (account_id, transaction_type, amount, status)
VALUES (4, 'DEPOSIT', 7500, 'SUCCESS');
commit;

COMMIT;

