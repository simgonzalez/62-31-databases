CREATE OR REPLACE PACKAGE pkg_compet IS
    PROCEDURE afficher_competition(p_com_no IN heg_competition.com_no%TYPE);
END pkg_compet;
/

CREATE OR REPLACE PACKAGE BODY pkg_compet IS

    FUNCTION retrieve_number_participant_from_compet_id(p_compet_id IN heg_competition.com_no%TYPE) RETURN INTEGER IS
        v_number_participant INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_number_participant FROM heg_participe WHERE par_com_no = p_compet_id;
        RETURN v_number_participant;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('La compétition ' || p_compet_id || ' n''existe pas');
            RETURN NULL;
        WHEN OTHERS THEN
            dbms_output.put_line('Erreur inconnue');
            RETURN NULL;
    END retrieve_number_participant_from_compet_id;

    FUNCTION retrieve_club_from_id(p_club_id IN heg_competition.com_clu_no%TYPE) RETURN heg_club%ROWTYPE IS
        v_club heg_club%ROWTYPE;
    BEGIN
        SELECT * INTO v_club FROM heg_club WHERE clu_no = p_club_id;

        RETURN v_club;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('Le club ' || p_club_id || ' n''existe pas');
            RETURN NULL;
        WHEN OTHERS THEN
            dbms_output.put_line('Erreur inconnue');
            RETURN NULL;
    END retrieve_club_from_id;

    FUNCTION retrieve_full_name_from_personne_id(p_personne_id IN heg_personne.per_no%TYPE) RETURN VARCHAR2 IS
        v_personne_details VARCHAR2(255);
    BEGIN
        SELECT per_nom || ' ' || per_prenom INTO v_personne_details FROM heg_personne WHERE per_no = p_personne_id;

        RETURN v_personne_details;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('La personne ' || p_personne_id || ' n''existe pas');
            RETURN NULL;
        WHEN OTHERS THEN
            dbms_output.put_line('Erreur inconnue');
            RETURN NULL;
    END retrieve_full_name_from_personne_id;

    PROCEDURE afficher_competition(p_com_no IN heg_competition.com_no%TYPE) IS
        v_competition                 heg_competition%ROWTYPE;
        v_club                        heg_club%ROWTYPE;
        v_time_to_competition_details VARCHAR2(255);
        v_number_participant          INTEGER;
        v_club_president              VARCHAR2(255) := '';
    BEGIN
        SELECT * INTO v_competition FROM heg_competition WHERE com_no = p_com_no;
        dbms_output.put_line('Compétition ' || v_competition.com_nom || ' du ' ||
                             TO_CHAR(v_competition.com_date, 'DD/MM/YY') || ' :');
        dbms_output.put_line('- Lieu : ' || v_competition.com_lieu || ' (' || v_competition.com_ville || ')');

        IF ABS(MONTHS_BETWEEN(v_competition.com_date, SYSDATE)) >= 2 THEN
            v_time_to_competition_details :=
                    TO_CHAR(ROUND(ABS(MONTHS_BETWEEN(v_competition.com_date, SYSDATE)))) || ' mois';
        ELSE
            v_time_to_competition_details := TO_CHAR(ROUND(ABS(v_competition.com_date - SYSDATE))) || ' jours';
        END IF;

        IF (v_competition.com_date - SYSDATE) > 0 THEN
            dbms_output.put_line('- Elle aura lieu dans ' || v_time_to_competition_details);
        ELSE
            dbms_output.put_line('- Elle a eu lieu il y a ' || v_time_to_competition_details);
        END IF;

        v_number_participant := retrieve_number_participant_from_compet_id(v_competition.com_no);
        IF v_number_participant = 1 THEN
            DECLARE
                v_participant_details VARCHAR2(255);
            BEGIN
                SELECT per_prenom || ' ' || per_nom || ' (' || hc.clu_nom || ')'
                INTO v_participant_details
                FROM heg_personne
                    INNER JOIN tp.heg_club hc ON hc.clu_no = heg_personne.per_clu_no
                WHERE per_no = (SELECT par_per_no FROM heg_participe WHERE par_com_no = v_competition.com_no);
                dbms_output.put_line('- seul participant : ' || v_participant_details);
            EXCEPTION
                WHEN no_data_found THEN
                    dbms_output.put_line('Erreur : le participant n''existe pas');
                WHEN OTHERS THEN
                    dbms_output.put_line('Erreur inconnue');
            END;
        ELSIF v_number_participant > 1 THEN
            dbms_output.put_line('- ' || v_number_participant ||
                                 ' participants');
        END IF;

        v_club := retrieve_club_from_id(v_competition.com_clu_no);
        IF v_club.clu_per_no IS NOT NULL THEN
            v_club_president := ' (Président: ' ||
                                retrieve_full_name_from_personne_id(v_club.clu_per_no) || ')';
        END IF;
        dbms_output.put_line('- Organisée par le ' || v_club.clu_nom || v_club_president);

        IF v_competition.com_prix IS NOT NULL THEN
            dbms_output.put_line('- Prix d''inscription : ' || v_competition.com_prix || '.-');
        END IF;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('La compétition no ' || p_com_no || ' n''existe pas');
        WHEN too_many_rows THEN
            dbms_output.put_line('Erreur : plusieurs compétitions portent le même numéro');
        WHEN OTHERS THEN
            dbms_output.put_line('Erreur inconnue');
    END afficher_competition;
END pkg_compet;
/