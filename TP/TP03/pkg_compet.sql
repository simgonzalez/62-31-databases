CREATE OR REPLACE PACKAGE pkg_compet IS
    PROCEDURE afficher_participation(i_per_no IN heg_personne.per_no%TYPE);
    PROCEDURE afficher_participation;
END pkg_compet;
/

CREATE OR REPLACE PACKAGE BODY pkg_compet IS

    PROCEDURE afficher_participation(i_per_no IN heg_personne.per_no%TYPE) IS
        v_personne heg_personne%ROWTYPE;
    BEGIN
        SELECT * INTO v_personne FROM heg_personne WHERE per_no = i_per_no;

        dbms_output.put(v_personne.per_prenom || ' ' || v_personne.per_nom || ' (no ' || i_per_no || ')');
        IF v_personne.per_clu_no IS NOT NULL THEN
            DECLARE
                v_club_nom      heg_club.clu_nom%TYPE;
                v_clu_president heg_club.clu_per_no%TYPE;
            BEGIN
                SELECT clu_nom, clu_per_no
                INTO v_club_nom, v_clu_president
                FROM heg_club
                WHERE clu_no = v_personne.per_clu_no;

                dbms_output.put(' est membre');
                IF v_personne.per_no = v_clu_president THEN
                    dbms_output.put(' et président');
                END IF;
                dbms_output.put_line(' du club ' || v_club_nom);
            END;
        ELSE
            dbms_output.put_line(' n''est membre d''aucun club');
        END IF;

        DECLARE
            v_count_participation INTEGER := 0;
        BEGIN
            IF v_personne.per_sexe = 'F' THEN
                dbms_output.put('Elle ');
            ELSE
                dbms_output.put('Il ');
            END IF;

            SELECT COUNT(*) INTO v_count_participation FROM heg_participe WHERE par_per_no = i_per_no;
            IF v_count_participation = 0 THEN
                dbms_output.put_line('n''a participé à aucune compétition');
            ELSE
                dbms_output.put_line('à participé aux compétitions suivantes :');
                DECLARE
                    v_count INTEGER := 0;
                BEGIN
                    FOR v_competition IN (SELECT *
                                          FROM heg_competition
                                          WHERE com_no IN
                                                (SELECT par_com_no FROM heg_participe WHERE par_per_no = i_per_no)
                                          ORDER BY com_date DESC)
                        LOOP
                            IF v_count > 2 THEN
                                dbms_output.put_line(' -  ... ainsi que ' || (v_count_participation - 3) ||
                                                     ' autres compétitions');
                                EXIT;
                            END IF;
                            dbms_output.put_line(' - ' || v_competition.com_nom || ' du ' ||
                                                 TO_CHAR(v_competition.com_date, 'dd/mm/yy') ||
                                                 ' à ' || v_competition.com_lieu);
                            v_count := v_count + 1;
                        END LOOP;
                END;
            END IF;
        END;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('La personne no ' || i_per_no || ' n''existe pas');
        WHEN OTHERS THEN
            dbms_output.put_line('Erreur inconnue : ' || SQLERRM);
    END afficher_participation;

    PROCEDURE afficher_participation IS
        CURSOR c_personnes IS SELECT *
                              FROM heg_personne;
    BEGIN
        FOR v_personne IN c_personnes
            LOOP
                afficher_participation(v_personne.per_no);
            END LOOP;
    END afficher_participation;

END pkg_compet;
/
