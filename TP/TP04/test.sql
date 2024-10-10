BEGIN
    pkg_compet.afficher_participants_competition(id_compet => 2);
    pkg_compet.afficher_participants_competition(id_compet => 5, is_sort_club => TRUE);
END;

