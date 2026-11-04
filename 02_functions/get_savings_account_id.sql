CREATE OR REPLACE FUNCTION get_savings_account_id (
    p_customer_id IN bank_accounts.customer_id%TYPE
) RETURN bank_accounts.account_id%TYPE IS
    v_account_id bank_accounts.account_id%TYPE;
BEGIN
    SELECT account_id INTO v_account_id
    FROM bank_accounts
    WHERE customer_id = p_customer_id AND account_type = 'SAVINGS';

    RETURN v_account_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20022,
            'Customer ' || p_customer_id || ' has no savings account.');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20023,
            'Customer ' || p_customer_id || ' has several savings accounts.');
END get_savings_account_id;
/
