DECLARE
    v_club_no              tp.heg_club.clu_no%TYPE;
    v_club_nom             tp.heg_club.clu_nom%TYPE;
    v_club_ville           tp.heg_club.clu_ville%TYPE;
    v_club_president       VARCHAR2(150);
    v_club_president_no    INT;
    v_club_nb_membres      INT;
    v_club_nb_competitions INT;
    v_club_prix_moyen      NUMBER(5, 2);
BEGIN
    -- retrieve club data
    SELECT clu_no,
           clu_nom,
           clu_ville,
           per_prenom || ' ' || per_nom,
           clu_per_no,
           (SELECT COUNT(per_no) FROM heg_personne WHERE per_clu_no = clu_no),
           (SELECT COUNT(com_no) FROM heg_competition WHERE com_clu_no = clu_no),
           (SELECT AVG(com_prix) FROM heg_competition WHERE com_clu_no = clu_no)
    INTO v_club_no, v_club_nom, v_club_ville, v_club_president, v_club_president_no, v_club_nb_membres, v_club_nb_competitions, v_club_prix_moyen
    FROM heg_club
        INNER JOIN tp.heg_personne hp ON hp.per_no = heg_club.clu_per_no
    WHERE LOWER(clu_nom) = 'heg-running'
    GROUP BY clu_no, clu_nom, clu_ville, per_prenom, per_nom, clu_per_no;

    -- show club data
    dbms_output.put_line('Données du club HEG-Running :');
    dbms_output.put_line('N° du club        : ' || v_club_no);
    dbms_output.put_line('Nom               : ' || v_club_nom);
    dbms_output.put_line('Ville             : ' || v_club_ville);
    dbms_output.put_line('Président         : ' || v_club_president || ' (n°' || v_club_president_no || ')');
    dbms_output.put_line('Nombre de membres : ' || v_club_nb_membres);
    dbms_output.put_line('Nombre de compétitions organisées : ' || v_club_nb_competitions || ', prix moyen : Frs ' ||
                         v_club_prix_moyen);
END;
/