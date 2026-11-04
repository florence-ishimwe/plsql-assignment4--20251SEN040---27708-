SET SERVEROUTPUT ON;

-- ERROR 1: Negative amount (expect ORA-20004)
DECLARE
    v_bal NUMBER;
BEGIN
    process_transaction(1, 'DEPOSIT', -50, v_bal);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR 1 caught: ' || SQLERRM);
END;
/

-- ERROR 2: Invalid transaction type (expect ORA-20006)
DECLARE
    v_bal NUMBER;
BEGIN
    process_transaction(1, 'TRANSFER', 100, v_bal);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR 2 caught: ' || SQLERRM);
END;
/

-- ERROR 3: Insufficient funds (expect ORA-20005)
DECLARE
    v_bal NUMBER;
BEGIN
    process_transaction(4, 'WITHDRAWAL', 999999, v_bal);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR 3 caught: ' || SQLERRM);
END;
/

-- ERROR 4: Account does not exist (expect ORA-20001)
DECLARE
    v_bal NUMBER;
BEGIN
    process_transaction(999, 'DEPOSIT', 100, v_bal);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR 4 caught: ' || SQLERRM);
END;
/

-- ERROR 5: Suspended account (expect ORA-20001)
DECLARE
    v_bal NUMBER;
BEGIN
    process_transaction(6, 'DEPOSIT', 100, v_bal);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR 5 caught: ' || SQLERRM);
END;
/

-- ERROR 6: Unknown account in function (expect ORA-20001)
BEGIN
    DBMS_OUTPUT.PUT_LINE(get_account_balance(999));
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR 6 caught: ' || SQLERRM);
END;
/

-- ERROR 7: Unknown customer (expect ORA-20003)
BEGIN
    DBMS_OUTPUT.PUT_LINE(get_customer_total_balance(99));
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR 7 caught: ' || SQLERRM);
END;
/

-- ERROR 8: TOO_MANY_ROWS (expect ORA-20023)
BEGIN
    DBMS_OUTPUT.PUT_LINE(get_savings_account_id(1));
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR 8 caught: ' || SQLERRM);
END;
/

-- ERROR 9: NULL interest rate (expect ORA-20010)
DECLARE
    v_count NUMBER;
BEGIN
    apply_monthly_interest(NULL, v_count);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR 9 caught: ' || SQLERRM);
END;
/

-- ERROR 10: Bulk DML errors with SAVE EXCEPTIONS (run LAST)
DECLARE
    v_count NUMBER;
BEGIN
    apply_monthly_interest(-2, v_count);
    DBMS_OUTPUT.PUT_LINE('Accounts updated despite errors: ' || v_count);
END;
/
