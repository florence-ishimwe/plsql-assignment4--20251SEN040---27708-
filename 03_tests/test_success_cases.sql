SET SERVEROUTPUT ON;

-- 1. Test get_account_balance function
DECLARE
    v_bal NUMBER;
BEGIN
    v_bal := get_account_balance(1);
    DBMS_OUTPUT.PUT_LINE('Account 1 Balance: ' || v_bal);
END;
/

-- 2. Test process_transaction procedure (Deposit)
DECLARE
    v_new_balance NUMBER;
BEGIN
    process_transaction(
        p_account_id  => 1,
        p_type        => 'DEPOSIT',
        p_amount      => 25000.00,
        p_new_balance => v_new_balance
    );
    DBMS_OUTPUT.PUT_LINE('New balance returned: ' || v_new_balance);
END;
/

-- 3. Test apply_monthly_interest procedure (Bulk Processing & Collections)
DECLARE
    v_updated NUMBER;
BEGIN
    apply_monthly_interest(
        p_interest_rate    => 0.03,
        p_accounts_updated => v_updated
    );
    DBMS_OUTPUT.PUT_LINE('Accounts updated: ' || v_updated);
END;
/

-- 4. Test get_customer_total_balance function
DECLARE
    v_total NUMBER;
BEGIN
    v_total := get_customer_total_balance(1);
    DBMS_OUTPUT.PUT_LINE('Customer 1 Total Balance: ' || v_total);
END;
/

-- 5. Verify the data
SELECT account_id, account_type, balance, status
FROM bank_accounts ORDER BY account_id;

SELECT transaction_id, account_id, transaction_type, amount, status
FROM bank_transactions ORDER BY transaction_id;
