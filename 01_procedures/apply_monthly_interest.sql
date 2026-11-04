CREATE OR REPLACE PROCEDURE apply_monthly_interest (
    p_interest_rate    IN  NUMBER DEFAULT 0.02,
    p_accounts_updated OUT NUMBER
) IS
    -- user-defined record
    TYPE t_account_rec IS RECORD (
        account_id bank_accounts.account_id%TYPE,
        balance    bank_accounts.balance%TYPE
    );

    -- nested table collection of records
    TYPE t_account_list IS TABLE OF t_account_rec;
    v_accounts t_account_list;

    -- explicit cursor
    CURSOR c_savings_accounts IS
        SELECT account_id, balance
        FROM bank_accounts
        WHERE account_type = 'SAVINGS' AND status = 'ACTIVE';

    bulk_errors EXCEPTION;
    PRAGMA EXCEPTION_INIT(bulk_errors, -24381);
BEGIN
    p_accounts_updated := 0;

    IF p_interest_rate IS NULL OR p_interest_rate > 1 THEN
        RAISE_APPLICATION_ERROR(-20010,
            'Interest rate must be provided and not exceed 1 (100%).');
    END IF;

    -- OPEN / FETCH BULK COLLECT / CLOSE
    OPEN c_savings_accounts;
    FETCH c_savings_accounts BULK COLLECT INTO v_accounts;
    CLOSE c_savings_accounts;

    IF v_accounts.COUNT > 0 THEN
        -- bulk DML with per-row error capture
        FORALL i IN 1..v_accounts.COUNT SAVE EXCEPTIONS
            UPDATE bank_accounts
            SET balance = balance + ROUND(v_accounts(i).balance * p_interest_rate, 2)
            WHERE account_id = v_accounts(i).account_id;

        p_accounts_updated := SQL%ROWCOUNT;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Interest applied to ' || p_accounts_updated
                             || ' savings accounts.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No active savings accounts found.');
    END IF;

EXCEPTION
    WHEN bulk_errors THEN
        p_accounts_updated := v_accounts.COUNT - SQL%BULK_EXCEPTIONS.COUNT;
        DBMS_OUTPUT.PUT_LINE('Bulk errors: ' || SQL%BULK_EXCEPTIONS.COUNT);
        FOR i IN 1..SQL%BULK_EXCEPTIONS.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Account '
                || v_accounts(SQL%BULK_EXCEPTIONS(i).ERROR_INDEX).account_id
                || ' failed: '
                || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
        END LOOP;
        COMMIT;  -- keep the rows that succeeded
    WHEN OTHERS THEN
        ROLLBACK;
        IF SQLCODE BETWEEN -20999 AND -20000 THEN
            RAISE;
        END IF;
        RAISE_APPLICATION_ERROR(-20099, 'Error applying interest: ' || SQLERRM);
END apply_monthly_interest;
/
