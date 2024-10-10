CREATE OR REPLACE PACKAGE pkg_compet IS
    PROCEDURE afficher_participants_competition(id_compet IN heg_competition.com_no%TYPE,
                                                is_sort_club IN BOOLEAN DEFAULT FALSE);
END pkg_compet;
/

CREATE OR REPLACE PACKAGE BODY pkg_compet IS
    PROCEDURE afficher_participants_competition(id_compet IN heg_competition.com_no%TYPE,
                                                is_sort_club IN BOOLEAN DEFAULT FALSE) IS
        v_compet heg_competition%ROWTYPE;
    BEGIN
        SELECT * INTO v_compet FROM heg_competition WHERE com_no = id_compet;
        dbms_output.put_line('Liste des participants au ' || v_compet.com_nom || ' du ' ||
                             TO_CHAR(v_compet.com_date, 'DD/MM/YY') || ' à ' || v_compet.com_lieu || ' (par ordre ' ||
                             CASE WHEN is_sort_club THEN 'des clubs' ELSE 'alphabétique' END || ')');
        DECLARE
            TYPE r_participant_info IS RECORD
                                       (
                                           per_nom    heg_personne.per_nom%TYPE,
                                           per_prenom heg_personne.per_prenom%TYPE,
                                           per_sexe   heg_personne.per_sexe%TYPE,
                                           clu_nom    heg_club.clu_nom%TYPE
                                       );
            c_participants        SYS_REFCURSOR;
            v_participant         r_participant_info;
            v_participant_details VARCHAR2(1000);
            v_query               VARCHAR2(500) :=
                'SELECT per_nom, per_prenom, per_sexe, clu_nom FROM heg_personne' ||
                ' INNER JOIN heg_participe ON par_per_no = per_no ' ||
                ' LEFT JOIN heg_club ON clu_no = per_clu_no' ||
                ' WHERE par_com_no = :id_compet';
        BEGIN
            IF is_sort_club THEN
                v_query := v_query || ' ORDER BY clu_nom, per_nom, per_prenom';
            ELSE
                v_query := v_query || ' ORDER BY per_nom, per_prenom';
            END IF;

            OPEN c_participants FOR v_query USING id_compet;
            FETCH c_participants INTO v_participant;
            WHILE c_participants%FOUND
                LOOP
                    v_participant_details :=
                            '- (' || v_participant.per_sexe || ') ' || v_participant.per_prenom || ' ' ||
                            v_participant.per_nom;
                    IF v_participant.clu_nom IS NOT NULL THEN
                        v_participant_details := v_participant_details || ' (' || v_participant.clu_nom || ')';
                    END IF;
                    dbms_output.put_line(v_participant_details);
                    FETCH c_participants INTO v_participant;
                END LOOP;
            CLOSE c_participants;
        EXCEPTION
            WHEN OTHERS THEN
                IF c_participants%ISOPEN THEN
                    CLOSE c_participants;
                END IF;
                dbms_output.put_line('Erreure innatendue ' || SQLERRM);
        END;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('pas de compétition avec l''id ' || id_compet);
    END afficher_participants_competition;
END pkg_compet;