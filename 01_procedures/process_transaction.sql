CREATE OR REPLACE PROCEDURE process_transaction (
    p_account_id  IN  bank_accounts.account_id%TYPE,
    p_type        IN  bank_transactions.transaction_type%TYPE,
    p_amount      IN  bank_transactions.amount%TYPE,
    p_new_balance OUT bank_accounts.balance%TYPE
) IS
    -- user-defined record for the transaction being processed
    TYPE t_txn_rec IS RECORD (
        account_id bank_transactions.account_id%TYPE,
        txn_type   bank_transactions.transaction_type%TYPE,
        amount     bank_transactions.amount%TYPE
    );
    v_txn     t_txn_rec;
    -- %ROWTYPE record for the account row
    v_account bank_accounts%ROWTYPE;

    e_insufficient_funds EXCEPTION;
    e_invalid_type       EXCEPTION;
BEGIN
    v_txn.account_id := p_account_id;
    v_txn.txn_type   := p_type;
    v_txn.amount     := p_amount;

    IF v_txn.amount IS NULL OR v_txn.amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20004,
            'Transaction amount must be greater than zero.');
    END IF;

    IF v_txn.txn_type NOT IN ('DEPOSIT', 'WITHDRAWAL') THEN
        RAISE e_invalid_type;
    END IF;

    -- lock and fetch the whole account row
    SELECT * INTO v_account
    FROM bank_accounts
    WHERE account_id = v_txn.account_id AND status = 'ACTIVE'
    FOR UPDATE;

    IF v_txn.txn_type = 'WITHDRAWAL' THEN
        IF v_account.balance < v_txn.amount THEN
            RAISE e_insufficient_funds;
        END IF;
        UPDATE bank_accounts SET balance = balance - v_txn.amount
        WHERE account_id = v_txn.account_id;
    ELSE
        UPDATE bank_accounts SET balance = balance + v_txn.amount
        WHERE account_id = v_txn.account_id;
    END IF;

    -- implicit cursor attributes
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Balance update affected no rows.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    INSERT INTO bank_transactions (account_id, transaction_type, amount, status)
    VALUES (v_txn.account_id, v_txn.txn_type, v_txn.amount, 'SUCCESS');

    SELECT balance INTO p_new_balance
    FROM bank_accounts WHERE account_id = v_txn.account_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE(v_txn.txn_type || ' successful. New balance: '
                         || p_new_balance);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Account not found or not active.');
    WHEN TOO_MANY_ROWS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Duplicate account records found.');
    WHEN e_insufficient_funds THEN
        ROLLBACK;
        INSERT INTO bank_transactions
            (account_id, transaction_type, amount, status, error_message)
        VALUES (v_txn.account_id, v_txn.txn_type, v_txn.amount,
                'FAILED', 'Insufficient funds');
        COMMIT;
        RAISE_APPLICATION_ERROR(-20005, 'Transaction failed: Insufficient funds.');
    WHEN e_invalid_type THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20006,
            'Invalid transaction type. Use DEPOSIT or WITHDRAWAL.');
    WHEN OTHERS THEN
        ROLLBACK;
        IF SQLCODE BETWEEN -20999 AND -20000 THEN
            RAISE;
        END IF;
        RAISE_APPLICATION_ERROR(-20099, 'Transaction error: ' || SQLERRM);
END process_transaction;
/
