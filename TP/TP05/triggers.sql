CREATE OR REPLACE TRIGGER trg_delete_compet
    AFTER DELETE
    ON heg_competition
    FOR EACH ROW
BEGIN
    DELETE FROM heg_participe WHERE par_com_no = :old.com_no;
END;
/

DECLARE
    v_start_no NUMBER := 1;
BEGIN
    SELECT MAX(com_no) + 1 INTO v_start_no FROM heg_competition;
    EXECUTE IMMEDIATE 'CREATE SEQUENCE tp.seq_per_no  INCREMENT BY 1 START WITH ' || v_start_no || ' nocycle';
END;
/

CREATE OR REPLACE TRIGGER trg_insert_person
    BEFORE INSERT
    ON heg_personne
    FOR EACH ROW
BEGIN
    :new.per_no := tp.seq_per_no.nextval;
END;
/

CREATE OR REPLACE TRIGGER trg_changement_club
    AFTER UPDATE OF per_clu_no
    ON heg_personne
    FOR EACH ROW
    WHEN (old.per_clu_no <> new.per_clu_no)
DECLARE
    v_old_club heg_club.clu_nom%TYPE;
    v_new_club heg_club.clu_nom%TYPE;
BEGIN
    SELECT clu_nom INTO v_old_club FROM heg_club WHERE clu_no = :old.per_clu_no;
    SELECT clu_nom INTO v_new_club FROM heg_club WHERE clu_no = :new.per_clu_no;
    dbms_output.put_line(:new.per_prenom || ' ' || :new.per_nom || ' a changé de club :');
    dbms_output.put_line('****************************************');
    dbms_output.put_line('Ancien club : ' || v_old_club);
    dbms_output.put_line('Nouveau club : ' || v_new_club);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('pas d''ancien club');
END;
/