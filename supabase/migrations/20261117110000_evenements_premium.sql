-- Deux évènements de plus pour la mesure de la bêta (3e passage du panel) :
-- l'export du livre de famille, et l'ouverture de l'offre Premium. À part,
-- parce qu'une valeur d'énumération ne peut pas servir dans la transaction qui
-- l'ajoute (voir 20261117120000_paiement_et_securite.sql).
alter type app_event_name add value if not exists 'family_export';
alter type app_event_name add value if not exists 'premium_view';
