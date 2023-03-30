SELECT * FROM dba_tab_columns
WHERE owner = 'DEVUSER';

--task 1

DECLARE
    CURSOR devTables IS
    SELECT * FROM DBA_TABLES
    WHERE owner = 'DEVUSER';
    CURSOR prodTables IS
    SELECT * FROM DBA_TABLES
    WHERE owner = 'PRODUSER';
    ch BOOLEAN;
    c NUMBER;
    col1 NUMBER;
    col2 NUMBER;
BEGIN
    FOR d IN devTables
    LOOP
        ch := FALSE;
        FOR p IN prodTables
        LOOP
            IF d.table_name = p.table_name THEN
                SELECT COUNT(*) INTO col1 FROM dba_tab_columns
                WHERE table_name = d.table_name AND owner = 'DEVUSER';
                SELECT COUNT(*) INTO col2 FROM dba_tab_columns
                WHERE table_name = p.table_name AND owner = 'PRODUSER';
                IF col1 = col2 THEN
                    c := 0;
                    FOR typesDev IN (SELECT column_name, data_type FROM dba_tab_columns WHERE table_name = d.table_name AND owner = 'DEVUSER')
                    LOOP
                        FOR typesProd IN (SELECT column_name, data_type FROM dba_tab_columns WHERE table_name = p.table_name AND owner = 'PRODUSER')
                        LOOP
                            IF typesDev.column_name = typesProd.column_name AND typesDev.data_type = typesProd.data_type THEN
                                c := c + 1;
                            END IF;
                        END LOOP;
                    END LOOP;
                    IF c = col1 THEN
                            ch := TRUE;
                    END IF;
                END IF;
            END IF;
        END LOOP;
        IF ch = FALSE THEN
            DBMS_OUTPUT.PUT_LINE(d.table_name);
        END IF;
    END LOOP;
END;
    
