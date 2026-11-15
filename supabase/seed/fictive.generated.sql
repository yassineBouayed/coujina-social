-- GÉNÉRÉ par `npm run seed:fictive` depuis data/fictive/*.json — ne pas modifier à la main.
-- Données FICTIVES : à charger sur une base de test, jamais en production.
begin;
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'amina_cuisine', 'Amina Benali', 'Marseillaise, cuisine de ma mère et de mes voyages. Le msemen du dimanche, c''est sacré.', now() - interval '60 days', current_terms_version(), now() - interval '60 days', now() - interval '60 days', now() - interval '60 days')
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = '69e35bef-6695-5b4f-89f7-684f67bd404c';
insert into profile_cuisines (profile_id, cuisine_slug) select '69e35bef-6695-5b4f-89f7-684f67bd404c', unnest(array['maghrebi', 'levantine', 'middle-eastern']::text[]);
delete from profile_exclusions where profile_id = '69e35bef-6695-5b4f-89f7-684f67bd404c';
insert into profile_exclusions (profile_id, flag) select '69e35bef-6695-5b4f-89f7-684f67bd404c', unnest(array['pork', 'alcohol']::dietary_flag[]);
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'lucas.bouffe', 'Lucas Martin', 'Cuisinier amateur à Lyon. Je teste tout, je modifie tout.', now() - interval '60 days', current_terms_version(), now() - interval '60 days', now() - interval '60 days', null)
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = 'ed018e6a-4007-5baf-bcf6-ab10a793deec';
insert into profile_cuisines (profile_id, cuisine_slug) select 'ed018e6a-4007-5baf-bcf6-ab10a793deec', unnest(array['french', 'mediterranean', 'western-european']::text[]);
delete from profile_exclusions where profile_id = 'ed018e6a-4007-5baf-bcf6-ab10a793deec';
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'priya_spice', 'Priya Raman', 'Végétarienne depuis toujours. Dal, curry et chaï.', now() - interval '60 days', current_terms_version(), now() - interval '60 days', now() - interval '60 days', now() - interval '60 days')
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = 'f81498e9-a866-50d7-a546-e0792b54c0c3';
insert into profile_cuisines (profile_id, cuisine_slug) select 'f81498e9-a866-50d7-a546-e0792b54c0c3', unnest(array['south-asian', 'southeast-asian']::text[]);
delete from profile_exclusions where profile_id = 'f81498e9-a866-50d7-a546-e0792b54c0c3';
insert into profile_exclusions (profile_id, flag) select 'f81498e9-a866-50d7-a546-e0792b54c0c3', unnest(array['meat', 'fish', 'shellfish']::dietary_flag[]);
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'kenji.ramen', 'Kenji Watanabe', 'Ramen, gyoza, et tout ce qui se mange avec des baguettes.', now() - interval '60 days', current_terms_version(), now() - interval '60 days', now() - interval '60 days', null)
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = '6f8af8f2-632e-57d6-b01e-705195e4132f';
insert into profile_cuisines (profile_id, cuisine_slug) select '6f8af8f2-632e-57d6-b01e-705195e4132f', unnest(array['east-asian', 'southeast-asian']::text[]);
delete from profile_exclusions where profile_id = '6f8af8f2-632e-57d6-b01e-705195e4132f';
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('29f4dd0f-206d-5413-a55f-b91340e3e561', 'fatou_dakar', 'Fatou Diop', 'Dakar - Paris. Le thiéboudienne n''a pas de recette, il a des familles.', now() - interval '60 days', current_terms_version(), now() - interval '60 days', now() - interval '60 days', now() - interval '60 days')
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = '29f4dd0f-206d-5413-a55f-b91340e3e561';
insert into profile_cuisines (profile_id, cuisine_slug) select '29f4dd0f-206d-5413-a55f-b91340e3e561', unnest(array['west-african', 'caribbean', 'east-african']::text[]);
delete from profile_exclusions where profile_id = '29f4dd0f-206d-5413-a55f-b91340e3e561';
insert into profile_exclusions (profile_id, flag) select '29f4dd0f-206d-5413-a55f-b91340e3e561', unnest(array['pork']::dietary_flag[]);
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('c6512930-0382-50bb-b18a-db918ff78f26', 'sofia.nonna', 'Sofia Russo', 'Cœliaque et gourmande : je réécris les classiques sans gluten.', now() - interval '60 days', current_terms_version(), now() - interval '60 days', now() - interval '60 days', now() - interval '60 days')
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = 'c6512930-0382-50bb-b18a-db918ff78f26';
insert into profile_cuisines (profile_id, cuisine_slug) select 'c6512930-0382-50bb-b18a-db918ff78f26', unnest(array['mediterranean', 'western-european']::text[]);
delete from profile_exclusions where profile_id = 'c6512930-0382-50bb-b18a-db918ff78f26';
insert into profile_exclusions (profile_id, flag) select 'c6512930-0382-50bb-b18a-db918ff78f26', unnest(array['gluten']::dietary_flag[]);
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'diego_tacos', 'Diego Hernández', 'Mexico, Buenos Aires, Lima. Allergique aux cacahuètes, pas aux piments.', now() - interval '60 days', current_terms_version(), now() - interval '60 days', now() - interval '60 days', now() - interval '60 days')
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2';
insert into profile_cuisines (profile_id, cuisine_slug) select 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', unnest(array['latin-american', 'north-american']::text[]);
delete from profile_exclusions where profile_id = 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2';
insert into profile_exclusions (profile_id, flag) select 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', unnest(array['peanut']::dietary_flag[]);
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'lea.vegan', 'Léa Dubois', 'Végane, je transforme les recettes de tout le monde.', now() - interval '60 days', current_terms_version(), now() - interval '60 days', now() - interval '60 days', now() - interval '60 days')
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = '3dd979f4-93c0-5058-8eb7-8e06046c8682';
insert into profile_cuisines (profile_id, cuisine_slug) select '3dd979f4-93c0-5058-8eb7-8e06046c8682', unnest(array['south-asian', 'mediterranean', 'southeast-asian', 'levantine']::text[]);
delete from profile_exclusions where profile_id = '3dd979f4-93c0-5058-8eb7-8e06046c8682';
insert into profile_exclusions (profile_id, flag) select '3dd979f4-93c0-5058-8eb7-8e06046c8682', unnest(array['meat', 'fish', 'shellfish', 'dairy', 'egg']::dietary_flag[]);
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'omar.grill', 'Omar Haddad', 'Beyrouth dans le cœur, le barbecue dans le jardin.', now() - interval '60 days', current_terms_version(), now() - interval '60 days', now() - interval '60 days', now() - interval '60 days')
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = '6181e113-9005-5113-87e3-2c5e1ce00abb';
insert into profile_cuisines (profile_id, cuisine_slug) select '6181e113-9005-5113-87e3-2c5e1ce00abb', unnest(array['levantine', 'middle-eastern']::text[]);
delete from profile_exclusions where profile_id = '6181e113-9005-5113-87e3-2c5e1ce00abb';
insert into profile_exclusions (profile_id, flag) select '6181e113-9005-5113-87e3-2c5e1ce00abb', unnest(array['pork', 'alcohol']::dietary_flag[]);
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('67c5aecd-680b-5574-aa4c-082784fe7707', 'nadia_patisse', 'Nadia Kowalski', 'Pâtisserie polonaise et française. Allergie aux fruits à coque.', now() - interval '60 days', current_terms_version(), now() - interval '60 days', now() - interval '60 days', now() - interval '60 days')
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = '67c5aecd-680b-5574-aa4c-082784fe7707';
insert into profile_cuisines (profile_id, cuisine_slug) select '67c5aecd-680b-5574-aa4c-082784fe7707', unnest(array['eastern-european', 'french']::text[]);
delete from profile_exclusions where profile_id = '67c5aecd-680b-5574-aa4c-082784fe7707';
insert into profile_exclusions (profile_id, flag) select '67c5aecd-680b-5574-aa4c-082784fe7707', unnest(array['tree_nut']::dietary_flag[]);
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b', 'tom.newbie', 'Tom Petit', '', null, null, null, null, null)
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = '549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b';
delete from profile_exclusions where profile_id = '549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b';
insert into profiles (id, username, display_name, bio, onboarded_at, terms_version, terms_accepted_at, age_confirmed_at, diet_consent_at)
  values ('ed48de41-79b0-595b-a0cd-984366f827e6', 'marie_prive', 'Marie Laurent', 'Je garde mes recettes de famille pour mes proches.', now() - interval '60 days', current_terms_version(), now() - interval '60 days', now() - interval '60 days', null)
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at,
    terms_version = excluded.terms_version, terms_accepted_at = excluded.terms_accepted_at, age_confirmed_at = excluded.age_confirmed_at, diet_consent_at = excluded.diet_consent_at;
delete from profile_cuisines where profile_id = 'ed48de41-79b0-595b-a0cd-984366f827e6';
insert into profile_cuisines (profile_id, cuisine_slug) select 'ed48de41-79b0-595b-a0cd-984366f827e6', unnest(array['french', 'eastern-european']::text[]);
delete from profile_exclusions where profile_id = 'ed48de41-79b0-595b-a0cd-984366f827e6';
insert into follows (follower_id, followee_id, created_at) values ('69e35bef-6695-5b4f-89f7-684f67bd404c', '6181e113-9005-5113-87e3-2c5e1ce00abb', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('69e35bef-6695-5b4f-89f7-684f67bd404c', '29f4dd0f-206d-5413-a55f-b91340e3e561', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'c0c0c0c0-0000-4000-8000-000000000001', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('ed018e6a-4007-5baf-bcf6-ab10a793deec', '69e35bef-6695-5b4f-89f7-684f67bd404c', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'c6512930-0382-50bb-b18a-db918ff78f26', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('ed018e6a-4007-5baf-bcf6-ab10a793deec', '67c5aecd-680b-5574-aa4c-082784fe7707', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'c0c0c0c0-0000-4000-8000-000000000001', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('f81498e9-a866-50d7-a546-e0792b54c0c3', '3dd979f4-93c0-5058-8eb7-8e06046c8682', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('f81498e9-a866-50d7-a546-e0792b54c0c3', '6f8af8f2-632e-57d6-b01e-705195e4132f', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'f81498e9-a866-50d7-a546-e0792b54c0c3', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('29f4dd0f-206d-5413-a55f-b91340e3e561', '69e35bef-6695-5b4f-89f7-684f67bd404c', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('29f4dd0f-206d-5413-a55f-b91340e3e561', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('c6512930-0382-50bb-b18a-db918ff78f26', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('c6512930-0382-50bb-b18a-db918ff78f26', '67c5aecd-680b-5574-aa4c-082784fe7707', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', '6f8af8f2-632e-57d6-b01e-705195e4132f', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', '29f4dd0f-206d-5413-a55f-b91340e3e561', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'f81498e9-a866-50d7-a546-e0792b54c0c3', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('3dd979f4-93c0-5058-8eb7-8e06046c8682', '69e35bef-6695-5b4f-89f7-684f67bd404c', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'c6512930-0382-50bb-b18a-db918ff78f26', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('6181e113-9005-5113-87e3-2c5e1ce00abb', '69e35bef-6695-5b4f-89f7-684f67bd404c', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('67c5aecd-680b-5574-aa4c-082784fe7707', 'ed48de41-79b0-595b-a0cd-984366f827e6', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('67c5aecd-680b-5574-aa4c-082784fe7707', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', now() - interval '40 days') on conflict do nothing;
insert into follows (follower_id, followee_id, created_at) values ('ed48de41-79b0-595b-a0cd-984366f827e6', '67c5aecd-680b-5574-aa4c-082784fe7707', now() - interval '40 days') on conflict do nothing;
insert into blocks (blocker_id, blocked_id) values ('c6512930-0382-50bb-b18a-db918ff78f26', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2') on conflict do nothing;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('154cf5f9-8f7b-5751-b9c8-c50b695803d2', '69e35bef-6695-5b4f-89f7-684f67bd404c', 'Msemen de ma mère', 'Msemen', 'Les crêpes feuilletées du petit-déjeuner, pliées comme chez nous.', 'maghrebi', 'maroc', 'bread', 'medium', 40, 20, 8, 'public', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['500 g de farine de blé', '100 g de semoule fine', '1 c. à c. de sel', '30 cl d''eau tiède', '80 g de beurre fondu', '10 cl d''huile']::text[]) || array[]::dietary_flag[]) f),
    null, null, null, now() - interval '290 hours', now() - interval '290 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 0, '500 g de farine de blé', '500 g de farine de blé'),
  ('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 1, '100 g de semoule fine', '100 g de semoule fine'),
  ('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 2, '1 c. à c. de sel', '1 c. à c. de sel'),
  ('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 3, '30 cl d''eau tiède', '30 cl d''eau tiède'),
  ('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 4, '80 g de beurre fondu', '80 g de beurre fondu'),
  ('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 5, '10 cl d''huile', '10 cl d''huile');
delete from recipe_steps where recipe_id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2';
insert into recipe_steps (recipe_id, position, body) values
  ('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 0, 'Mélanger farine, semoule et sel, ajouter l''eau peu à peu et pétrir 10 minutes.'),
  ('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 1, 'Former des boules, huiler et laisser reposer 15 minutes.'),
  ('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 2, 'Étaler très finement, badigeonner de beurre, saupoudrer de semoule et plier en carré.'),
  ('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 3, 'Cuire à la poêle 3 minutes de chaque côté.');
insert into recipe_media (id, recipe_id, owner_id, kind, storage_path, public_url, position) values ('d4118cf2-8f7c-564f-937d-3332cd7fd214', '154cf5f9-8f7b-5751-b9c8-c50b695803d2', '69e35bef-6695-5b4f-89f7-684f67bd404c', 'video', '69e35bef-6695-5b4f-89f7-684f67bd404c/msemen-amina.mp4', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', 0) on conflict (id) do nothing;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('11aea93a-ace6-5b4a-96ff-d65b9831833c', '69e35bef-6695-5b4f-89f7-684f67bd404c', 'Harira du ramadan', 'Harira', 'Réservée à mes abonnés : la version de la famille.', 'maghrebi', 'maroc', 'soup', 'medium', 30, 90, 6, 'followers', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['300 g d''agneau en dés', '150 g de lentilles', '150 g de pois chiches trempés', '4 tomates', '1 oignon', '1 bouquet de coriandre', '1 bouquet de persil', '50 g de vermicelles', '2 c. à s. de farine']::text[]) || array[]::dietary_flag[]) f),
    null, null, null, now() - interval '74 hours', now() - interval '74 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '11aea93a-ace6-5b4a-96ff-d65b9831833c';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 0, '300 g d''agneau en dés', '300 g d''agneau en dés'),
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 1, '150 g de lentilles', '150 g de lentilles'),
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 2, '150 g de pois chiches trempés', '150 g de pois chiches trempés'),
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 3, '4 tomates', '4 tomates'),
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 4, '1 oignon', '1 oignon'),
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 5, '1 bouquet de coriandre', '1 bouquet de coriandre'),
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 6, '1 bouquet de persil', '1 bouquet de persil'),
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 7, '50 g de vermicelles', '50 g de vermicelles'),
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 8, '2 c. à s. de farine', '2 c. à s. de farine');
delete from recipe_steps where recipe_id = '11aea93a-ace6-5b4a-96ff-d65b9831833c';
insert into recipe_steps (recipe_id, position, body) values
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 0, 'Faire revenir l''agneau et l''oignon.'),
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 1, 'Ajouter tomates mixées, lentilles, pois chiches, herbes et 2 l d''eau ; cuire 1 h.'),
  ('11aea93a-ace6-5b4a-96ff-d65b9831833c', 2, 'Lier avec la farine délayée, ajouter les vermicelles, cuire 10 minutes.');
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', 'Blanquette du dimanche', null, '', 'french', 'france', 'main', 'medium', 30, 120, 6, 'public', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['1,2 kg de veau', '2 carottes', '1 oignon piqué de clous de girofle', '250 g de champignons', '20 cl de crème fraîche', '2 jaunes d''œufs', '40 g de beurre', '40 g de farine']::text[]) || array[]::dietary_flag[]) f),
    null, null, null, now() - interval '482 hours', now() - interval '482 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = 'be4fb989-6ff1-5d00-b6d2-0ba0044929cf';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 0, '1,2 kg de veau', '1,2 kg de veau'),
  ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 1, '2 carottes', '2 carottes'),
  ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 2, '1 oignon piqué de clous de girofle', '1 oignon piqué de clous de girofle'),
  ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 3, '250 g de champignons', '250 g de champignons'),
  ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 4, '20 cl de crème fraîche', '20 cl de crème fraîche'),
  ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 5, '2 jaunes d''œufs', '2 jaunes d''œufs'),
  ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 6, '40 g de beurre', '40 g de beurre'),
  ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 7, '40 g de farine', '40 g de farine');
delete from recipe_steps where recipe_id = 'be4fb989-6ff1-5d00-b6d2-0ba0044929cf';
insert into recipe_steps (recipe_id, position, body) values
  ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 0, 'Blanchir la viande, puis la cuire 1 h 30 avec les légumes dans l''eau froide.'),
  ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 1, 'Faire un roux, mouiller avec le bouillon filtré.'),
  ('be4fb989-6ff1-5d00-b6d2-0ba0044929cf', 2, 'Lier hors du feu avec crème et jaunes, remettre la viande.');
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', 'Msemen au miel et à la fleur d''oranger', 'Msemen', 'La recette d''Amina, avec un sirop de miel en plus.', 'maghrebi', 'maroc', 'bread', 'medium', 40, 20, 8, 'public', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['500 g de farine de blé', '100 g de semoule fine', '1 c. à c. de sel', '30 cl d''eau tiède', '80 g de beurre fondu', '10 cl d''huile', '4 c. à s. de miel', '1 c. à s. d''eau de fleur d''oranger']::text[]) || array[]::dietary_flag[]) f),
    '154cf5f9-8f7b-5751-b9c8-c50b695803d2', '69e35bef-6695-5b4f-89f7-684f67bd404c', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', now() - interval '50 hours', now() - interval '50 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '32d1076d-a903-57bd-9a0e-319e544ccaf1';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 0, '500 g de farine de blé', '500 g de farine de blé'),
  ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 1, '100 g de semoule fine', '100 g de semoule fine'),
  ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 2, '1 c. à c. de sel', '1 c. à c. de sel'),
  ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 3, '30 cl d''eau tiède', '30 cl d''eau tiède'),
  ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 4, '80 g de beurre fondu', '80 g de beurre fondu'),
  ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 5, '10 cl d''huile', '10 cl d''huile'),
  ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 6, '4 c. à s. de miel', '4 c. à s. de miel'),
  ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 7, '1 c. à s. d''eau de fleur d''oranger', '1 c. à s. d''eau de fleur d''oranger');
delete from recipe_steps where recipe_id = '32d1076d-a903-57bd-9a0e-319e544ccaf1';
insert into recipe_steps (recipe_id, position, body) values
  ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 0, 'Pétrir comme la recette d''origine.'),
  ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 1, 'Plier et cuire de la même façon.'),
  ('32d1076d-a903-57bd-9a0e-319e544ccaf1', 2, 'Chauffer miel et fleur d''oranger, napper à la sortie de la poêle.');
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('52211fb0-4762-5b71-8664-a5a7ae92b432', '154cf5f9-8f7b-5751-b9c8-c50b695803d2', '32d1076d-a903-57bd-9a0e-319e544ccaf1', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', true, now() - interval '50 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 'f81498e9-a866-50d7-a546-e0792b54c0c3', 'Dal tadka express', null, '', 'south-asian', 'inde', 'main', 'easy', 10, 25, 4, 'public', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['250 g de lentilles corail', '1 oignon', '2 tomates', '1 c. à c. de curcuma', '1 c. à c. de cumin en grains', '2 gousses d''ail', '2 c. à s. d''huile']::text[]) || array[]::dietary_flag[]) f),
    null, null, null, now() - interval '26 hours', now() - interval '26 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 0, '250 g de lentilles corail', '250 g de lentilles corail'),
  ('c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 1, '1 oignon', '1 oignon'),
  ('c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 2, '2 tomates', '2 tomates'),
  ('c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 3, '1 c. à c. de curcuma', '1 c. à c. de curcuma'),
  ('c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 4, '1 c. à c. de cumin en grains', '1 c. à c. de cumin en grains'),
  ('c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 5, '2 gousses d''ail', '2 gousses d''ail'),
  ('c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 6, '2 c. à s. d''huile', '2 c. à s. d''huile');
delete from recipe_steps where recipe_id = 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a';
insert into recipe_steps (recipe_id, position, body) values
  ('c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 0, 'Cuire les lentilles avec le curcuma 20 minutes.'),
  ('c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 1, 'Faire crépiter le cumin dans l''huile, ajouter ail, oignon, tomates.'),
  ('c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 2, 'Verser le tadka sur le dal.');
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('986d4826-1115-59f6-b668-fa6ab24923e6', '6f8af8f2-632e-57d6-b01e-705195e4132f', 'Ramen shoyu maison', '醤油ラーメン', '', 'east-asian', 'japon', 'soup', 'hard', 60, 240, 4, 'public', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['1 carcasse de poulet', '4 portions de nouilles ramen', '10 cl de sauce soja', '2 c. à s. de mirin', '4 œufs', '2 oignons nouveaux', '1 morceau de gingembre']::text[]) || array[]::dietary_flag[]) f),
    null, null, null, now() - interval '146 hours', now() - interval '146 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '986d4826-1115-59f6-b668-fa6ab24923e6';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('986d4826-1115-59f6-b668-fa6ab24923e6', 0, '1 carcasse de poulet', '1 carcasse de poulet'),
  ('986d4826-1115-59f6-b668-fa6ab24923e6', 1, '4 portions de nouilles ramen', '4 portions de nouilles ramen'),
  ('986d4826-1115-59f6-b668-fa6ab24923e6', 2, '10 cl de sauce soja', '10 cl de sauce soja'),
  ('986d4826-1115-59f6-b668-fa6ab24923e6', 3, '2 c. à s. de mirin', '2 c. à s. de mirin'),
  ('986d4826-1115-59f6-b668-fa6ab24923e6', 4, '4 œufs', '4 œufs'),
  ('986d4826-1115-59f6-b668-fa6ab24923e6', 5, '2 oignons nouveaux', '2 oignons nouveaux'),
  ('986d4826-1115-59f6-b668-fa6ab24923e6', 6, '1 morceau de gingembre', '1 morceau de gingembre');
delete from recipe_steps where recipe_id = '986d4826-1115-59f6-b668-fa6ab24923e6';
insert into recipe_steps (recipe_id, position, body) values
  ('986d4826-1115-59f6-b668-fa6ab24923e6', 0, 'Cuire la carcasse 4 h à frémissement avec gingembre.'),
  ('986d4826-1115-59f6-b668-fa6ab24923e6', 1, 'Mariner les œufs mollets dans soja et mirin.'),
  ('986d4826-1115-59f6-b668-fa6ab24923e6', 2, 'Assembler tare, bouillon, nouilles et garnitures.');
insert into recipe_media (id, recipe_id, owner_id, kind, storage_path, public_url, position) values ('c5e9349c-06f0-558b-a11f-a995e2ea7d92', '986d4826-1115-59f6-b668-fa6ab24923e6', '6f8af8f2-632e-57d6-b01e-705195e4132f', 'video', '6f8af8f2-632e-57d6-b01e-705195e4132f/ramen-kenji.mp4', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', 0) on conflict (id) do nothing;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('37ea3b45-7834-560c-a16d-347c624ddc91', '29f4dd0f-206d-5413-a55f-b91340e3e561', 'Thiéboudienne de Fatou', 'Ceebu jën', '', 'west-african', 'senegal', 'main', 'hard', 45, 90, 6, 'public', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['1 kg de poisson (thiof ou mérou)', '500 g de riz brisé', '1 bouquet de persil', '3 c. à s. de concentré de tomate', '1 chou', '2 carottes', '1 aubergine', '1 manioc']::text[]) || array[]::dietary_flag[]) f),
    null, null, null, now() - interval '218 hours', now() - interval '218 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '37ea3b45-7834-560c-a16d-347c624ddc91';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('37ea3b45-7834-560c-a16d-347c624ddc91', 0, '1 kg de poisson (thiof ou mérou)', '1 kg de poisson (thiof ou mérou)'),
  ('37ea3b45-7834-560c-a16d-347c624ddc91', 1, '500 g de riz brisé', '500 g de riz brisé'),
  ('37ea3b45-7834-560c-a16d-347c624ddc91', 2, '1 bouquet de persil', '1 bouquet de persil'),
  ('37ea3b45-7834-560c-a16d-347c624ddc91', 3, '3 c. à s. de concentré de tomate', '3 c. à s. de concentré de tomate'),
  ('37ea3b45-7834-560c-a16d-347c624ddc91', 4, '1 chou', '1 chou'),
  ('37ea3b45-7834-560c-a16d-347c624ddc91', 5, '2 carottes', '2 carottes'),
  ('37ea3b45-7834-560c-a16d-347c624ddc91', 6, '1 aubergine', '1 aubergine'),
  ('37ea3b45-7834-560c-a16d-347c624ddc91', 7, '1 manioc', '1 manioc');
delete from recipe_steps where recipe_id = '37ea3b45-7834-560c-a16d-347c624ddc91';
insert into recipe_steps (recipe_id, position, body) values
  ('37ea3b45-7834-560c-a16d-347c624ddc91', 0, 'Farcir le poisson au roff (persil, ail, piment).'),
  ('37ea3b45-7834-560c-a16d-347c624ddc91', 1, 'Cuire légumes et poisson dans la sauce tomate.'),
  ('37ea3b45-7834-560c-a16d-347c624ddc91', 2, 'Cuire le riz dans le bouillon jusqu''au xooñ.');
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('f4134598-19a8-5684-8ad4-3f26f1c91929', 'c6512930-0382-50bb-b18a-db918ff78f26', 'Lasagnes sans gluten', null, '', 'mediterranean', 'italie', 'main', 'medium', 40, 45, 6, 'public', null, array['dairy', 'meat']::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['12 feuilles de lasagnes sans gluten', '500 g de bœuf haché', '70 cl de coulis de tomate', '50 cl de lait', '40 g de fécule de maïs', '100 g de parmesan']::text[]) || array['dairy', 'meat']::dietary_flag[]) f),
    null, null, null, now() - interval '362 hours', now() - interval '362 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = 'f4134598-19a8-5684-8ad4-3f26f1c91929';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('f4134598-19a8-5684-8ad4-3f26f1c91929', 0, '12 feuilles de lasagnes sans gluten', '12 feuilles de lasagnes sans gluten'),
  ('f4134598-19a8-5684-8ad4-3f26f1c91929', 1, '500 g de bœuf haché', '500 g de bœuf haché'),
  ('f4134598-19a8-5684-8ad4-3f26f1c91929', 2, '70 cl de coulis de tomate', '70 cl de coulis de tomate'),
  ('f4134598-19a8-5684-8ad4-3f26f1c91929', 3, '50 cl de lait', '50 cl de lait'),
  ('f4134598-19a8-5684-8ad4-3f26f1c91929', 4, '40 g de fécule de maïs', '40 g de fécule de maïs'),
  ('f4134598-19a8-5684-8ad4-3f26f1c91929', 5, '100 g de parmesan', '100 g de parmesan');
delete from recipe_steps where recipe_id = 'f4134598-19a8-5684-8ad4-3f26f1c91929';
insert into recipe_steps (recipe_id, position, body) values
  ('f4134598-19a8-5684-8ad4-3f26f1c91929', 0, 'Préparer une bolognaise.'),
  ('f4134598-19a8-5684-8ad4-3f26f1c91929', 1, 'Béchamel à la fécule de maïs.'),
  ('f4134598-19a8-5684-8ad4-3f26f1c91929', 2, 'Monter en couches et cuire 45 minutes à 180 °C.');
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('19b6fd5b-a771-522a-ace0-70a67067a544', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'Tacos al pastor de Diego', 'Tacos al pastor', '', 'latin-american', 'mexique', 'main', 'medium', 30, 30, 4, 'public', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['800 g d''échine de porc', '3 piments guajillo', '1/2 ananas', '12 tortillas de maïs', '1 oignon blanc', '1 bouquet de coriandre']::text[]) || array[]::dietary_flag[]) f),
    null, null, null, now() - interval '98 hours', now() - interval '98 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '19b6fd5b-a771-522a-ace0-70a67067a544';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('19b6fd5b-a771-522a-ace0-70a67067a544', 0, '800 g d''échine de porc', '800 g d''échine de porc'),
  ('19b6fd5b-a771-522a-ace0-70a67067a544', 1, '3 piments guajillo', '3 piments guajillo'),
  ('19b6fd5b-a771-522a-ace0-70a67067a544', 2, '1/2 ananas', '1/2 ananas'),
  ('19b6fd5b-a771-522a-ace0-70a67067a544', 3, '12 tortillas de maïs', '12 tortillas de maïs'),
  ('19b6fd5b-a771-522a-ace0-70a67067a544', 4, '1 oignon blanc', '1 oignon blanc'),
  ('19b6fd5b-a771-522a-ace0-70a67067a544', 5, '1 bouquet de coriandre', '1 bouquet de coriandre');
delete from recipe_steps where recipe_id = '19b6fd5b-a771-522a-ace0-70a67067a544';
insert into recipe_steps (recipe_id, position, body) values
  ('19b6fd5b-a771-522a-ace0-70a67067a544', 0, 'Mariner le porc une nuit dans les piments.'),
  ('19b6fd5b-a771-522a-ace0-70a67067a544', 1, 'Griller avec l''ananas.'),
  ('19b6fd5b-a771-522a-ace0-70a67067a544', 2, 'Servir dans les tortillas chaudes.');
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('3f0de9c8-e489-54ae-9da1-b4c419f90451', '3dd979f4-93c0-5058-8eb7-8e06046c8682', 'Curry vert végane', null, '', 'southeast-asian', 'thailande', 'main', 'easy', 15, 20, 4, 'public', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['2 c. à s. de pâte de curry vert', '40 cl de lait de coco', '300 g de tofu ferme', '1 courgette', '1 poivron', '1 bouquet de basilic thaï']::text[]) || array[]::dietary_flag[]) f),
    null, null, null, now() - interval '2 hours', now() - interval '2 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '3f0de9c8-e489-54ae-9da1-b4c419f90451';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('3f0de9c8-e489-54ae-9da1-b4c419f90451', 0, '2 c. à s. de pâte de curry vert', '2 c. à s. de pâte de curry vert'),
  ('3f0de9c8-e489-54ae-9da1-b4c419f90451', 1, '40 cl de lait de coco', '40 cl de lait de coco'),
  ('3f0de9c8-e489-54ae-9da1-b4c419f90451', 2, '300 g de tofu ferme', '300 g de tofu ferme'),
  ('3f0de9c8-e489-54ae-9da1-b4c419f90451', 3, '1 courgette', '1 courgette'),
  ('3f0de9c8-e489-54ae-9da1-b4c419f90451', 4, '1 poivron', '1 poivron'),
  ('3f0de9c8-e489-54ae-9da1-b4c419f90451', 5, '1 bouquet de basilic thaï', '1 bouquet de basilic thaï');
delete from recipe_steps where recipe_id = '3f0de9c8-e489-54ae-9da1-b4c419f90451';
insert into recipe_steps (recipe_id, position, body) values
  ('3f0de9c8-e489-54ae-9da1-b4c419f90451', 0, 'Faire revenir la pâte dans un peu de lait de coco.'),
  ('3f0de9c8-e489-54ae-9da1-b4c419f90451', 1, 'Ajouter légumes et tofu, puis le reste du lait de coco.'),
  ('3f0de9c8-e489-54ae-9da1-b4c419f90451', 2, 'Finir avec le basilic.');
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773', '6181e113-9005-5113-87e3-2c5e1ce00abb', 'Shish taouk mariné 24 h', 'شيش طاووق', '', 'levantine', 'liban', 'main', 'easy', 20, 15, 4, 'public', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['800 g de blancs de poulet', '15 cl de yaourt', '3 gousses d''ail', '1 citron', '1 c. à s. de paprika', '2 c. à s. d''huile d''olive']::text[]) || array[]::dietary_flag[]) f),
    null, null, null, now() - interval '122 hours', now() - interval '122 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773', 0, '800 g de blancs de poulet', '800 g de blancs de poulet'),
  ('2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773', 1, '15 cl de yaourt', '15 cl de yaourt'),
  ('2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773', 2, '3 gousses d''ail', '3 gousses d''ail'),
  ('2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773', 3, '1 citron', '1 citron'),
  ('2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773', 4, '1 c. à s. de paprika', '1 c. à s. de paprika'),
  ('2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773', 5, '2 c. à s. d''huile d''olive', '2 c. à s. d''huile d''olive');
delete from recipe_steps where recipe_id = '2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773';
insert into recipe_steps (recipe_id, position, body) values
  ('2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773', 0, 'Mariner le poulet 24 h.'),
  ('2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773', 1, 'Embrocher et griller 12 à 15 minutes.'),
  ('2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773', 2, 'Servir avec toum et pain.');
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('7fe979fb-9be5-5747-b26e-88fb796989cd', 'ed48de41-79b0-595b-a0cd-984366f827e6', 'Gratin secret de mamie', null, '', 'french', 'france', 'side', 'easy', 20, 60, 6, 'private', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['1,5 kg de pommes de terre', '50 cl de crème', '25 cl de lait', '1 gousse d''ail', '1 pincée de muscade']::text[]) || array[]::dietary_flag[]) f),
    null, null, null, now() - interval '722 hours', now() - interval '722 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '7fe979fb-9be5-5747-b26e-88fb796989cd';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('7fe979fb-9be5-5747-b26e-88fb796989cd', 0, '1,5 kg de pommes de terre', '1,5 kg de pommes de terre'),
  ('7fe979fb-9be5-5747-b26e-88fb796989cd', 1, '50 cl de crème', '50 cl de crème'),
  ('7fe979fb-9be5-5747-b26e-88fb796989cd', 2, '25 cl de lait', '25 cl de lait'),
  ('7fe979fb-9be5-5747-b26e-88fb796989cd', 3, '1 gousse d''ail', '1 gousse d''ail'),
  ('7fe979fb-9be5-5747-b26e-88fb796989cd', 4, '1 pincée de muscade', '1 pincée de muscade');
delete from recipe_steps where recipe_id = '7fe979fb-9be5-5747-b26e-88fb796989cd';
insert into recipe_steps (recipe_id, position, body) values
  ('7fe979fb-9be5-5747-b26e-88fb796989cd', 0, 'Trancher finement les pommes de terre.'),
  ('7fe979fb-9be5-5747-b26e-88fb796989cd', 1, 'Frotter le plat à l''ail, ranger les tranches.'),
  ('7fe979fb-9be5-5747-b26e-88fb796989cd', 2, 'Couvrir de crème et lait, cuire 1 h à 160 °C.');
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('d311b89b-5143-56e3-9090-f3d65f707025', 'ed48de41-79b0-595b-a0cd-984366f827e6', 'Tarte Tatin de la famille', null, '', 'french', 'france', 'dessert', 'medium', 30, 45, 8, 'followers', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['1 pâte brisée', '8 pommes', '150 g de sucre', '80 g de beurre']::text[]) || array[]::dietary_flag[]) f),
    null, null, null, now() - interval '194 hours', now() - interval '194 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = 'd311b89b-5143-56e3-9090-f3d65f707025';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('d311b89b-5143-56e3-9090-f3d65f707025', 0, '1 pâte brisée', '1 pâte brisée'),
  ('d311b89b-5143-56e3-9090-f3d65f707025', 1, '8 pommes', '8 pommes'),
  ('d311b89b-5143-56e3-9090-f3d65f707025', 2, '150 g de sucre', '150 g de sucre'),
  ('d311b89b-5143-56e3-9090-f3d65f707025', 3, '80 g de beurre', '80 g de beurre');
delete from recipe_steps where recipe_id = 'd311b89b-5143-56e3-9090-f3d65f707025';
insert into recipe_steps (recipe_id, position, body) values
  ('d311b89b-5143-56e3-9090-f3d65f707025', 0, 'Caraméliser sucre et beurre dans le moule.'),
  ('d311b89b-5143-56e3-9090-f3d65f707025', 1, 'Ranger les pommes serrées, cuire 20 minutes.'),
  ('d311b89b-5143-56e3-9090-f3d65f707025', 2, 'Couvrir de pâte, cuire 25 minutes, retourner tiède.');
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('0cdd1fe9-6e85-52be-b135-ec0521845838', '67c5aecd-680b-5574-aa4c-082784fe7707', 'Tarte Tatin aux poires', null, '', 'french', 'france', 'dessert', 'medium', 30, 45, 8, 'followers', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['1 pâte brisée', '6 poires', '150 g de sucre', '80 g de beurre', '1 gousse de vanille']::text[]) || array[]::dietary_flag[]) f),
    'd311b89b-5143-56e3-9090-f3d65f707025', 'ed48de41-79b0-595b-a0cd-984366f827e6', '67c5aecd-680b-5574-aa4c-082784fe7707', now() - interval '26 hours', now() - interval '26 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '0cdd1fe9-6e85-52be-b135-ec0521845838';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('0cdd1fe9-6e85-52be-b135-ec0521845838', 0, '1 pâte brisée', '1 pâte brisée'),
  ('0cdd1fe9-6e85-52be-b135-ec0521845838', 1, '6 poires', '6 poires'),
  ('0cdd1fe9-6e85-52be-b135-ec0521845838', 2, '150 g de sucre', '150 g de sucre'),
  ('0cdd1fe9-6e85-52be-b135-ec0521845838', 3, '80 g de beurre', '80 g de beurre'),
  ('0cdd1fe9-6e85-52be-b135-ec0521845838', 4, '1 gousse de vanille', '1 gousse de vanille');
delete from recipe_steps where recipe_id = '0cdd1fe9-6e85-52be-b135-ec0521845838';
insert into recipe_steps (recipe_id, position, body) values
  ('0cdd1fe9-6e85-52be-b135-ec0521845838', 0, 'Caraméliser sucre, beurre et vanille.'),
  ('0cdd1fe9-6e85-52be-b135-ec0521845838', 1, 'Ranger les poires, cuire 15 minutes.'),
  ('0cdd1fe9-6e85-52be-b135-ec0521845838', 2, 'Couvrir de pâte, cuire 25 minutes, retourner tiède.');
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('755c7e11-7e7e-562c-994b-eb08ae11c18e', 'd311b89b-5143-56e3-9090-f3d65f707025', '0cdd1fe9-6e85-52be-b135-ec0521845838', '67c5aecd-680b-5574-aa4c-082784fe7707', true, now() - interval '26 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('11014cbe-2751-5e01-9aac-a5db633adefc', '3dd979f4-93c0-5058-8eb7-8e06046c8682', 'Dal tadka au lait de coco', null, '', 'south-asian', 'inde', 'main', 'easy', 10, 25, 4, 'public', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['250 g de lentilles corail', '20 cl de lait de coco', '1 oignon', '2 tomates', '1 c. à c. de curcuma', '1 c. à c. de cumin en grains', '2 c. à s. d''huile']::text[]) || array[]::dietary_flag[]) f),
    'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', 'f81498e9-a866-50d7-a546-e0792b54c0c3', '3dd979f4-93c0-5058-8eb7-8e06046c8682', now() - interval '2 hours', now() - interval '2 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '11014cbe-2751-5e01-9aac-a5db633adefc';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('11014cbe-2751-5e01-9aac-a5db633adefc', 0, '250 g de lentilles corail', '250 g de lentilles corail'),
  ('11014cbe-2751-5e01-9aac-a5db633adefc', 1, '20 cl de lait de coco', '20 cl de lait de coco'),
  ('11014cbe-2751-5e01-9aac-a5db633adefc', 2, '1 oignon', '1 oignon'),
  ('11014cbe-2751-5e01-9aac-a5db633adefc', 3, '2 tomates', '2 tomates'),
  ('11014cbe-2751-5e01-9aac-a5db633adefc', 4, '1 c. à c. de curcuma', '1 c. à c. de curcuma'),
  ('11014cbe-2751-5e01-9aac-a5db633adefc', 5, '1 c. à c. de cumin en grains', '1 c. à c. de cumin en grains'),
  ('11014cbe-2751-5e01-9aac-a5db633adefc', 6, '2 c. à s. d''huile', '2 c. à s. d''huile');
delete from recipe_steps where recipe_id = '11014cbe-2751-5e01-9aac-a5db633adefc';
insert into recipe_steps (recipe_id, position, body) values
  ('11014cbe-2751-5e01-9aac-a5db633adefc', 0, 'Cuire les lentilles avec curcuma et lait de coco.'),
  ('11014cbe-2751-5e01-9aac-a5db633adefc', 1, 'Préparer le tadka.'),
  ('11014cbe-2751-5e01-9aac-a5db633adefc', 2, 'Verser et servir avec du riz.');
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b53b52d7-d83d-501c-b879-dac9807f77e7', 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', '11014cbe-2751-5e01-9aac-a5db633adefc', '3dd979f4-93c0-5058-8eb7-8e06046c8682', true, now() - interval '2 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values ('814daf3a-dced-5f39-b6e5-864b080ba873', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'Jollof rice au chipotle', null, 'La recette du livre couJina, avec du chipotle fumé à la place du piment frais.', 'west-african', 'nigeria', 'main', 'medium', 20, 45, 6, 'public', null, array[]::dietary_flag[],
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(array['500 g de riz long', '4 tomates', '2 poivrons rouges', '2 piments chipotle', '1 oignon', '2 c. à s. de concentré de tomate', '50 cl de bouillon']::text[]) || array[]::dietary_flag[]) f),
    '23b1127c-bbcb-5318-af9d-53f178823322', 'c0c0c0c0-0000-4000-8000-000000000001', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', now() - interval '74 hours', now() - interval '74 hours')
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;
delete from recipe_ingredients where recipe_id = '814daf3a-dced-5f39-b6e5-864b080ba873';
insert into recipe_ingredients (recipe_id, position, raw, item) values
  ('814daf3a-dced-5f39-b6e5-864b080ba873', 0, '500 g de riz long', '500 g de riz long'),
  ('814daf3a-dced-5f39-b6e5-864b080ba873', 1, '4 tomates', '4 tomates'),
  ('814daf3a-dced-5f39-b6e5-864b080ba873', 2, '2 poivrons rouges', '2 poivrons rouges'),
  ('814daf3a-dced-5f39-b6e5-864b080ba873', 3, '2 piments chipotle', '2 piments chipotle'),
  ('814daf3a-dced-5f39-b6e5-864b080ba873', 4, '1 oignon', '1 oignon'),
  ('814daf3a-dced-5f39-b6e5-864b080ba873', 5, '2 c. à s. de concentré de tomate', '2 c. à s. de concentré de tomate'),
  ('814daf3a-dced-5f39-b6e5-864b080ba873', 6, '50 cl de bouillon', '50 cl de bouillon');
delete from recipe_steps where recipe_id = '814daf3a-dced-5f39-b6e5-864b080ba873';
insert into recipe_steps (recipe_id, position, body) values
  ('814daf3a-dced-5f39-b6e5-864b080ba873', 0, 'Mixer tomates, poivrons, chipotle et oignon.'),
  ('814daf3a-dced-5f39-b6e5-864b080ba873', 1, 'Réduire la sauce 20 minutes avec le concentré.'),
  ('814daf3a-dced-5f39-b6e5-864b080ba873', 2, 'Cuire le riz dans la sauce et le bouillon, à couvert.');
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('0aec28de-32de-5413-bc9b-f3d0d189861b', '23b1127c-bbcb-5318-af9d-53f178823322', '814daf3a-dced-5f39-b6e5-864b080ba873', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', true, now() - interval '74 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '0db33016-8eb6-58b0-90f9-fa03de106c50', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '7 hours', now() - interval '7 hours'
    from recipes where id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '0db33016-8eb6-58b0-90f9-fa03de106c50', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '0db33016-8eb6-58b0-90f9-fa03de106c50', position, body, minutes from recipe_steps where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('e622b05d-d2f6-553f-bf81-18ecbbdc4232', 'c4e96d6b-02b0-5e7b-8d39-9121414f4120', '0db33016-8eb6-58b0-90f9-fa03de106c50', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '7 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'd76bd077-5aa6-5528-a037-71fbbf5e1005', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '4 hours', now() - interval '4 hours'
    from recipes where id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'd76bd077-5aa6-5528-a037-71fbbf5e1005', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'd76bd077-5aa6-5528-a037-71fbbf5e1005', position, body, minutes from recipe_steps where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('9d916f29-159a-55f4-a6ed-b45e8eaef1a9', 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e', 'd76bd077-5aa6-5528-a037-71fbbf5e1005', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '4 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'd0389fc9-f78b-5da6-a6ab-83a3d77e34d3', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '97 hours', now() - interval '97 hours'
    from recipes where id = 'a77c7f55-df1d-5e60-9237-26e165f42815'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'd0389fc9-f78b-5da6-a6ab-83a3d77e34d3', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'd0389fc9-f78b-5da6-a6ab-83a3d77e34d3', position, body, minutes from recipe_steps where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('6d58e971-b5ff-54f7-bccf-e33ab4fe0fc0', 'a77c7f55-df1d-5e60-9237-26e165f42815', 'd0389fc9-f78b-5da6-a6ab-83a3d77e34d3', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '97 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '4318118c-5d6b-50a2-b7d1-a59c3858e778', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '8 hours', now() - interval '8 hours'
    from recipes where id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '4318118c-5d6b-50a2-b7d1-a59c3858e778', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '4318118c-5d6b-50a2-b7d1-a59c3858e778', position, body, minutes from recipe_steps where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('616a3f3a-4fbb-5520-bfb5-8db2b8bc15fe', '68fd660b-26ef-59f1-b3e2-ed6dee544fa5', '4318118c-5d6b-50a2-b7d1-a59c3858e778', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '8 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'f2febed2-6ef9-54b1-b535-788fa46e0ab9', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '14 hours', now() - interval '14 hours'
    from recipes where id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'f2febed2-6ef9-54b1-b535-788fa46e0ab9', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'f2febed2-6ef9-54b1-b535-788fa46e0ab9', position, body, minutes from recipe_steps where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('52afc8f1-2ddf-5412-b3d7-7ddfd3981ec2', '849520c0-e1e5-5dfd-a8c9-b7f79252267e', 'f2febed2-6ef9-54b1-b535-788fa46e0ab9', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '14 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'e8c2a8bf-3caf-5b51-ae3f-8e275bae26cb', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '49 hours', now() - interval '49 hours'
    from recipes where id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'e8c2a8bf-3caf-5b51-ae3f-8e275bae26cb', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'e8c2a8bf-3caf-5b51-ae3f-8e275bae26cb', position, body, minutes from recipe_steps where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('abe83a9b-0ecb-5f83-979d-c5f84df8c2c3', 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8', 'e8c2a8bf-3caf-5b51-ae3f-8e275bae26cb', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '49 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '7a790ae5-90d7-5a09-ae41-e9ca780fc22b', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '1 hours', now() - interval '1 hours'
    from recipes where id = '23b1127c-bbcb-5318-af9d-53f178823322'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '7a790ae5-90d7-5a09-ae41-e9ca780fc22b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '7a790ae5-90d7-5a09-ae41-e9ca780fc22b', position, body, minutes from recipe_steps where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('cf9ea4df-2d46-53f2-94bc-c11638501045', '23b1127c-bbcb-5318-af9d-53f178823322', '7a790ae5-90d7-5a09-ae41-e9ca780fc22b', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '1 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'a6445a66-52b7-53f5-ac9a-90010d8aafa7', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '684 hours', now() - interval '684 hours'
    from recipes where id = '5a91a7b6-6f17-572a-b788-cdd51e350851'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'a6445a66-52b7-53f5-ac9a-90010d8aafa7', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '5a91a7b6-6f17-572a-b788-cdd51e350851' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'a6445a66-52b7-53f5-ac9a-90010d8aafa7', position, body, minutes from recipe_steps where recipe_id = '5a91a7b6-6f17-572a-b788-cdd51e350851' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('f2ff045b-83bb-5066-b6ff-e9eb2e43c7f1', '5a91a7b6-6f17-572a-b788-cdd51e350851', 'a6445a66-52b7-53f5-ac9a-90010d8aafa7', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '684 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '1f92ff34-79d6-5e69-99e5-6f851748cf65', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '7 hours', now() - interval '7 hours'
    from recipes where id = '913f8bbf-f25b-5e30-9676-b4f88f8b1383'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '1f92ff34-79d6-5e69-99e5-6f851748cf65', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '913f8bbf-f25b-5e30-9676-b4f88f8b1383' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '1f92ff34-79d6-5e69-99e5-6f851748cf65', position, body, minutes from recipe_steps where recipe_id = '913f8bbf-f25b-5e30-9676-b4f88f8b1383' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('32d4bcae-a33c-5e28-9a1f-73e7961362a4', '913f8bbf-f25b-5e30-9676-b4f88f8b1383', '1f92ff34-79d6-5e69-99e5-6f851748cf65', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '7 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'cf19306c-c6c4-5961-b059-943bd41192ff', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '624 hours', now() - interval '624 hours'
    from recipes where id = 'a41de7ef-deab-53ec-b1b1-3c4094fb9894'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'cf19306c-c6c4-5961-b059-943bd41192ff', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a41de7ef-deab-53ec-b1b1-3c4094fb9894' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'cf19306c-c6c4-5961-b059-943bd41192ff', position, body, minutes from recipe_steps where recipe_id = 'a41de7ef-deab-53ec-b1b1-3c4094fb9894' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('480f7081-3162-5004-b7fe-b8bcf1b54ae9', 'a41de7ef-deab-53ec-b1b1-3c4094fb9894', 'cf19306c-c6c4-5961-b059-943bd41192ff', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '624 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '71547ff3-28f0-52a2-aadf-42253f4b2060', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '1 hours', now() - interval '1 hours'
    from recipes where id = '39644e0b-14a4-5c16-af47-3dd37e231625'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '71547ff3-28f0-52a2-aadf-42253f4b2060', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '39644e0b-14a4-5c16-af47-3dd37e231625' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '71547ff3-28f0-52a2-aadf-42253f4b2060', position, body, minutes from recipe_steps where recipe_id = '39644e0b-14a4-5c16-af47-3dd37e231625' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('f05e9413-c93c-5ed3-bdb3-17a2cae2ecb6', '39644e0b-14a4-5c16-af47-3dd37e231625', '71547ff3-28f0-52a2-aadf-42253f4b2060', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '1 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'f57eb196-0990-59e8-9305-b23a7a1d2e36', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '383 hours', now() - interval '383 hours'
    from recipes where id = '2cffbfd3-18a4-5358-86af-f2a6439b65a6'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'f57eb196-0990-59e8-9305-b23a7a1d2e36', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '2cffbfd3-18a4-5358-86af-f2a6439b65a6' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'f57eb196-0990-59e8-9305-b23a7a1d2e36', position, body, minutes from recipe_steps where recipe_id = '2cffbfd3-18a4-5358-86af-f2a6439b65a6' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('120f1eb8-d495-5c33-97e6-011154b5cf8b', '2cffbfd3-18a4-5358-86af-f2a6439b65a6', 'f57eb196-0990-59e8-9305-b23a7a1d2e36', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '383 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '8d19ffd7-4a89-514d-a1c0-3a2b80cbfec2', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '367 hours', now() - interval '367 hours'
    from recipes where id = '2fbad0ef-a0a4-5bc0-92ab-97c4b2ed7229'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '8d19ffd7-4a89-514d-a1c0-3a2b80cbfec2', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '2fbad0ef-a0a4-5bc0-92ab-97c4b2ed7229' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '8d19ffd7-4a89-514d-a1c0-3a2b80cbfec2', position, body, minutes from recipe_steps where recipe_id = '2fbad0ef-a0a4-5bc0-92ab-97c4b2ed7229' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('41314afc-fd37-58b9-a974-67312495113a', '2fbad0ef-a0a4-5bc0-92ab-97c4b2ed7229', '8d19ffd7-4a89-514d-a1c0-3a2b80cbfec2', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '367 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '718691ea-e505-5bf5-a07c-f5078176af7b', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '22 hours', now() - interval '22 hours'
    from recipes where id = 'ff7559f4-308d-5e02-9815-7da88aef5b7a'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '718691ea-e505-5bf5-a07c-f5078176af7b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'ff7559f4-308d-5e02-9815-7da88aef5b7a' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '718691ea-e505-5bf5-a07c-f5078176af7b', position, body, minutes from recipe_steps where recipe_id = 'ff7559f4-308d-5e02-9815-7da88aef5b7a' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('772b13d4-a003-55c3-91e1-c43aa5aeb581', 'ff7559f4-308d-5e02-9815-7da88aef5b7a', '718691ea-e505-5bf5-a07c-f5078176af7b', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '22 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '1c396cec-3fa1-5030-a7a1-dc22026b4723', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '50 hours', now() - interval '50 hours'
    from recipes where id = 'ba135134-d6a3-585f-9176-a71469995678'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '1c396cec-3fa1-5030-a7a1-dc22026b4723', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'ba135134-d6a3-585f-9176-a71469995678' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '1c396cec-3fa1-5030-a7a1-dc22026b4723', position, body, minutes from recipe_steps where recipe_id = 'ba135134-d6a3-585f-9176-a71469995678' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('47c6215e-03dd-5a2a-b96a-d48de2360df1', 'ba135134-d6a3-585f-9176-a71469995678', '1c396cec-3fa1-5030-a7a1-dc22026b4723', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '50 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'c6620858-049c-5af4-91c3-29d1e144c956', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '584 hours', now() - interval '584 hours'
    from recipes where id = '4dfbccbb-850e-5275-bc12-cb3771d715ab'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'c6620858-049c-5af4-91c3-29d1e144c956', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '4dfbccbb-850e-5275-bc12-cb3771d715ab' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'c6620858-049c-5af4-91c3-29d1e144c956', position, body, minutes from recipe_steps where recipe_id = '4dfbccbb-850e-5275-bc12-cb3771d715ab' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('7ef336a2-30b5-52ad-9b8b-6fb813eafe57', '4dfbccbb-850e-5275-bc12-cb3771d715ab', 'c6620858-049c-5af4-91c3-29d1e144c956', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '584 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '35293850-e8b6-5ecd-86fe-1ac4e618875b', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '136 hours', now() - interval '136 hours'
    from recipes where id = 'c5c1cab6-9458-544f-9492-dcd2da3e0d79'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '35293850-e8b6-5ecd-86fe-1ac4e618875b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5c1cab6-9458-544f-9492-dcd2da3e0d79' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '35293850-e8b6-5ecd-86fe-1ac4e618875b', position, body, minutes from recipe_steps where recipe_id = 'c5c1cab6-9458-544f-9492-dcd2da3e0d79' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b387b569-87f0-53f6-89c7-acd5a7b40bdd', 'c5c1cab6-9458-544f-9492-dcd2da3e0d79', '35293850-e8b6-5ecd-86fe-1ac4e618875b', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '136 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'a08c0107-3317-5ebe-9201-a8bdf4b690d2', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '692 hours', now() - interval '692 hours'
    from recipes where id = '1fe992cb-fe5a-5dc6-9c13-67039962c1fe'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'a08c0107-3317-5ebe-9201-a8bdf4b690d2', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '1fe992cb-fe5a-5dc6-9c13-67039962c1fe' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'a08c0107-3317-5ebe-9201-a8bdf4b690d2', position, body, minutes from recipe_steps where recipe_id = '1fe992cb-fe5a-5dc6-9c13-67039962c1fe' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('8831158e-51e3-5996-81b8-2fefc0295897', '1fe992cb-fe5a-5dc6-9c13-67039962c1fe', 'a08c0107-3317-5ebe-9201-a8bdf4b690d2', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '692 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'c35f1c26-f6ba-5cb2-be96-b8d8ed215b6a', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '2 hours', now() - interval '2 hours'
    from recipes where id = '5dc8aa33-f44e-544f-a42c-a5962edd13c0'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'c35f1c26-f6ba-5cb2-be96-b8d8ed215b6a', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '5dc8aa33-f44e-544f-a42c-a5962edd13c0' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'c35f1c26-f6ba-5cb2-be96-b8d8ed215b6a', position, body, minutes from recipe_steps where recipe_id = '5dc8aa33-f44e-544f-a42c-a5962edd13c0' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b098ccba-f1dc-52a7-bfbb-7c7b01f9c49e', '5dc8aa33-f44e-544f-a42c-a5962edd13c0', 'c35f1c26-f6ba-5cb2-be96-b8d8ed215b6a', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '2 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '109e83a5-4ff3-5061-b9d6-7e7b52b0c7f6', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '4 hours', now() - interval '4 hours'
    from recipes where id = 'c4a1f59d-b5c2-55c1-9f50-57fed5a605ba'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '109e83a5-4ff3-5061-b9d6-7e7b52b0c7f6', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c4a1f59d-b5c2-55c1-9f50-57fed5a605ba' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '109e83a5-4ff3-5061-b9d6-7e7b52b0c7f6', position, body, minutes from recipe_steps where recipe_id = 'c4a1f59d-b5c2-55c1-9f50-57fed5a605ba' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('adb3a3db-b31e-524b-b7a1-766619e4d258', 'c4a1f59d-b5c2-55c1-9f50-57fed5a605ba', '109e83a5-4ff3-5061-b9d6-7e7b52b0c7f6', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '4 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '27c27890-528e-504f-8912-6cbc359155b4', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '21 hours', now() - interval '21 hours'
    from recipes where id = '022e4281-7764-5de4-b3cd-21db907d5c0d'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '27c27890-528e-504f-8912-6cbc359155b4', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '022e4281-7764-5de4-b3cd-21db907d5c0d' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '27c27890-528e-504f-8912-6cbc359155b4', position, body, minutes from recipe_steps where recipe_id = '022e4281-7764-5de4-b3cd-21db907d5c0d' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('bd226469-0400-5d4b-9b61-1d3848a5744a', '022e4281-7764-5de4-b3cd-21db907d5c0d', '27c27890-528e-504f-8912-6cbc359155b4', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '21 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '20109795-cb1c-5f93-b983-c7ea011c8f7f', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '504 hours', now() - interval '504 hours'
    from recipes where id = 'bce49ace-d955-506e-be88-6bd8ccfc3ba2'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '20109795-cb1c-5f93-b983-c7ea011c8f7f', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'bce49ace-d955-506e-be88-6bd8ccfc3ba2' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '20109795-cb1c-5f93-b983-c7ea011c8f7f', position, body, minutes from recipe_steps where recipe_id = 'bce49ace-d955-506e-be88-6bd8ccfc3ba2' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('947c7b07-5f77-5d0d-a059-91229f128f9a', 'bce49ace-d955-506e-be88-6bd8ccfc3ba2', '20109795-cb1c-5f93-b983-c7ea011c8f7f', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '504 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '68cc0281-b8fa-52ca-807e-6865e599854d', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '12 hours', now() - interval '12 hours'
    from recipes where id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '68cc0281-b8fa-52ca-807e-6865e599854d', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '68cc0281-b8fa-52ca-807e-6865e599854d', position, body, minutes from recipe_steps where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b760ff2c-4e22-5763-ba1f-4363776aab4a', 'c4e96d6b-02b0-5e7b-8d39-9121414f4120', '68cc0281-b8fa-52ca-807e-6865e599854d', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '12 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '0440b020-4892-5356-9766-7b7153b78fbf', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '19 hours', now() - interval '19 hours'
    from recipes where id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '0440b020-4892-5356-9766-7b7153b78fbf', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '0440b020-4892-5356-9766-7b7153b78fbf', position, body, minutes from recipe_steps where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('56b1f5d2-246b-5c67-b2a8-d77cb3d90165', 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e', '0440b020-4892-5356-9766-7b7153b78fbf', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '19 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'dd07f71f-b799-53d6-8df3-0801ce7106ca', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '4 hours', now() - interval '4 hours'
    from recipes where id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'dd07f71f-b799-53d6-8df3-0801ce7106ca', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'dd07f71f-b799-53d6-8df3-0801ce7106ca', position, body, minutes from recipe_steps where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('e5be589d-adc1-511d-8e96-87efd036500b', '68fd660b-26ef-59f1-b3e2-ed6dee544fa5', 'dd07f71f-b799-53d6-8df3-0801ce7106ca', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '4 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '9e0493d5-5e8d-5683-846d-7b09cb24f788', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '56 hours', now() - interval '56 hours'
    from recipes where id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '9e0493d5-5e8d-5683-846d-7b09cb24f788', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '9e0493d5-5e8d-5683-846d-7b09cb24f788', position, body, minutes from recipe_steps where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('69e68dc3-b619-52ad-890e-9c9713728797', 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8', '9e0493d5-5e8d-5683-846d-7b09cb24f788', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '56 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '5d5546d6-55a9-50d2-b633-1bad77826207', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '100 hours', now() - interval '100 hours'
    from recipes where id = '23b1127c-bbcb-5318-af9d-53f178823322'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '5d5546d6-55a9-50d2-b633-1bad77826207', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '5d5546d6-55a9-50d2-b633-1bad77826207', position, body, minutes from recipe_steps where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('ba377e5f-1676-5328-9742-29d85ee61b22', '23b1127c-bbcb-5318-af9d-53f178823322', '5d5546d6-55a9-50d2-b633-1bad77826207', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '100 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '0fa66eec-3c72-5dbb-9c5e-26d5ec0a06ea', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '3 hours', now() - interval '3 hours'
    from recipes where id = '9aac8da2-3db6-52db-aebe-fe9ef5b6837d'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '0fa66eec-3c72-5dbb-9c5e-26d5ec0a06ea', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '9aac8da2-3db6-52db-aebe-fe9ef5b6837d' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '0fa66eec-3c72-5dbb-9c5e-26d5ec0a06ea', position, body, minutes from recipe_steps where recipe_id = '9aac8da2-3db6-52db-aebe-fe9ef5b6837d' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('d2fb8241-21ac-5d1a-b0fc-7f6eaa8a4313', '9aac8da2-3db6-52db-aebe-fe9ef5b6837d', '0fa66eec-3c72-5dbb-9c5e-26d5ec0a06ea', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '3 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '7dfa0606-e58d-5dcf-9d72-a6bd6bd6081c', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '291 hours', now() - interval '291 hours'
    from recipes where id = '5abab15f-2664-56b6-9717-80a62722f68e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '7dfa0606-e58d-5dcf-9d72-a6bd6bd6081c', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '5abab15f-2664-56b6-9717-80a62722f68e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '7dfa0606-e58d-5dcf-9d72-a6bd6bd6081c', position, body, minutes from recipe_steps where recipe_id = '5abab15f-2664-56b6-9717-80a62722f68e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('f4e8db27-8280-54f3-add2-5c9856b7ab88', '5abab15f-2664-56b6-9717-80a62722f68e', '7dfa0606-e58d-5dcf-9d72-a6bd6bd6081c', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '291 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '86db927c-e5db-5fff-ab9c-5a7cf4f17e0c', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '274 hours', now() - interval '274 hours'
    from recipes where id = '6b0db58c-ae4f-54d6-8fbc-fa765a413026'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '86db927c-e5db-5fff-ab9c-5a7cf4f17e0c', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '6b0db58c-ae4f-54d6-8fbc-fa765a413026' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '86db927c-e5db-5fff-ab9c-5a7cf4f17e0c', position, body, minutes from recipe_steps where recipe_id = '6b0db58c-ae4f-54d6-8fbc-fa765a413026' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('bdef579a-ac08-54df-8397-4209e5389414', '6b0db58c-ae4f-54d6-8fbc-fa765a413026', '86db927c-e5db-5fff-ab9c-5a7cf4f17e0c', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '274 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '31428302-8c41-5daf-9302-df0b8d5eb5cb', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '13 hours', now() - interval '13 hours'
    from recipes where id = 'ab4472d0-44b3-5576-97a0-a164aebcd5a1'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '31428302-8c41-5daf-9302-df0b8d5eb5cb', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'ab4472d0-44b3-5576-97a0-a164aebcd5a1' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '31428302-8c41-5daf-9302-df0b8d5eb5cb', position, body, minutes from recipe_steps where recipe_id = 'ab4472d0-44b3-5576-97a0-a164aebcd5a1' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('1395b518-914f-51f0-bb42-147d0333d6a8', 'ab4472d0-44b3-5576-97a0-a164aebcd5a1', '31428302-8c41-5daf-9302-df0b8d5eb5cb', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '13 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '06f35fd6-b175-5c08-885d-e1550d34a908', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '279 hours', now() - interval '279 hours'
    from recipes where id = 'e75893c3-d053-5270-97ae-1728ae4f59be'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '06f35fd6-b175-5c08-885d-e1550d34a908', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e75893c3-d053-5270-97ae-1728ae4f59be' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '06f35fd6-b175-5c08-885d-e1550d34a908', position, body, minutes from recipe_steps where recipe_id = 'e75893c3-d053-5270-97ae-1728ae4f59be' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('5efe3d62-7003-5648-a96a-ea2c81531c0d', 'e75893c3-d053-5270-97ae-1728ae4f59be', '06f35fd6-b175-5c08-885d-e1550d34a908', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '279 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '2b604123-fbc3-54e2-8dc3-755b457d0565', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '20 hours', now() - interval '20 hours'
    from recipes where id = 'a94ce22f-2273-5245-a160-b5508c12ce49'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '2b604123-fbc3-54e2-8dc3-755b457d0565', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a94ce22f-2273-5245-a160-b5508c12ce49' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '2b604123-fbc3-54e2-8dc3-755b457d0565', position, body, minutes from recipe_steps where recipe_id = 'a94ce22f-2273-5245-a160-b5508c12ce49' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('2f3ff56a-812f-5399-9d76-73a41b6d961b', 'a94ce22f-2273-5245-a160-b5508c12ce49', '2b604123-fbc3-54e2-8dc3-755b457d0565', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '20 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'd7004655-10e3-5b98-8f15-7108b83a107b', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '77 hours', now() - interval '77 hours'
    from recipes where id = 'c0d02def-358a-5ddf-8354-9e9660449f90'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'd7004655-10e3-5b98-8f15-7108b83a107b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c0d02def-358a-5ddf-8354-9e9660449f90' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'd7004655-10e3-5b98-8f15-7108b83a107b', position, body, minutes from recipe_steps where recipe_id = 'c0d02def-358a-5ddf-8354-9e9660449f90' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('9f91dd58-1edb-53c1-a1a0-fdd578f3e742', 'c0d02def-358a-5ddf-8354-9e9660449f90', 'd7004655-10e3-5b98-8f15-7108b83a107b', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '77 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'ac0ed377-4200-5ec2-ad62-e052a9d43e9b', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '574 hours', now() - interval '574 hours'
    from recipes where id = 'f2912cd9-6584-547c-ba9b-0dcd37b77195'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'ac0ed377-4200-5ec2-ad62-e052a9d43e9b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'f2912cd9-6584-547c-ba9b-0dcd37b77195' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'ac0ed377-4200-5ec2-ad62-e052a9d43e9b', position, body, minutes from recipe_steps where recipe_id = 'f2912cd9-6584-547c-ba9b-0dcd37b77195' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('d64d68fc-ed06-5e9f-9455-205cf88fa18d', 'f2912cd9-6584-547c-ba9b-0dcd37b77195', 'ac0ed377-4200-5ec2-ad62-e052a9d43e9b', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '574 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'ce0285d5-0641-5cbc-a217-441cc73a4fac', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '57 hours', now() - interval '57 hours'
    from recipes where id = '24b8d433-9c07-5e9a-aa75-286f2ec6aaca'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'ce0285d5-0641-5cbc-a217-441cc73a4fac', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '24b8d433-9c07-5e9a-aa75-286f2ec6aaca' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'ce0285d5-0641-5cbc-a217-441cc73a4fac', position, body, minutes from recipe_steps where recipe_id = '24b8d433-9c07-5e9a-aa75-286f2ec6aaca' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('9c6f3107-90da-53db-855d-48ed62efc94e', '24b8d433-9c07-5e9a-aa75-286f2ec6aaca', 'ce0285d5-0641-5cbc-a217-441cc73a4fac', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '57 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'ad990274-cd3f-5c34-b15d-0da912498735', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '244 hours', now() - interval '244 hours'
    from recipes where id = '7d947231-ff8e-5f11-9876-c48305873514'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'ad990274-cd3f-5c34-b15d-0da912498735', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '7d947231-ff8e-5f11-9876-c48305873514' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'ad990274-cd3f-5c34-b15d-0da912498735', position, body, minutes from recipe_steps where recipe_id = '7d947231-ff8e-5f11-9876-c48305873514' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('24f31cbf-fadc-5147-afda-f6e1370ffc94', '7d947231-ff8e-5f11-9876-c48305873514', 'ad990274-cd3f-5c34-b15d-0da912498735', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '244 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '57151221-bc42-542a-96d5-02b509667291', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '4 hours', now() - interval '4 hours'
    from recipes where id = '18b94020-4bfe-5973-a8dc-a440d1cde344'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '57151221-bc42-542a-96d5-02b509667291', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '18b94020-4bfe-5973-a8dc-a440d1cde344' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '57151221-bc42-542a-96d5-02b509667291', position, body, minutes from recipe_steps where recipe_id = '18b94020-4bfe-5973-a8dc-a440d1cde344' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('051aacca-5149-5708-98fc-b4665891f180', '18b94020-4bfe-5973-a8dc-a440d1cde344', '57151221-bc42-542a-96d5-02b509667291', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '4 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '986f5d55-9c6e-5071-b3db-3560f1a916f9', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '217 hours', now() - interval '217 hours'
    from recipes where id = 'b1f0a9c0-18f8-5410-b28e-f5d78153b220'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '986f5d55-9c6e-5071-b3db-3560f1a916f9', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'b1f0a9c0-18f8-5410-b28e-f5d78153b220' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '986f5d55-9c6e-5071-b3db-3560f1a916f9', position, body, minutes from recipe_steps where recipe_id = 'b1f0a9c0-18f8-5410-b28e-f5d78153b220' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('f3dcd29c-6dbe-5c40-bd0e-dee1d7ccaa9d', 'b1f0a9c0-18f8-5410-b28e-f5d78153b220', '986f5d55-9c6e-5071-b3db-3560f1a916f9', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '217 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'e610e17d-c18d-5cf6-8419-11cf35514cfa', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '106 hours', now() - interval '106 hours'
    from recipes where id = '5b2291d1-acd0-5105-9ed9-e014dd7707e5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'e610e17d-c18d-5cf6-8419-11cf35514cfa', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '5b2291d1-acd0-5105-9ed9-e014dd7707e5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'e610e17d-c18d-5cf6-8419-11cf35514cfa', position, body, minutes from recipe_steps where recipe_id = '5b2291d1-acd0-5105-9ed9-e014dd7707e5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('4ef94837-3af7-5a9c-9c4d-ee18ff13fd3d', '5b2291d1-acd0-5105-9ed9-e014dd7707e5', 'e610e17d-c18d-5cf6-8419-11cf35514cfa', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '106 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '53fa1958-e53f-53a7-8931-70c9b1c199f4', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '11 hours', now() - interval '11 hours'
    from recipes where id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '53fa1958-e53f-53a7-8931-70c9b1c199f4', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '53fa1958-e53f-53a7-8931-70c9b1c199f4', position, body, minutes from recipe_steps where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('80a975f4-c6b8-582f-b451-3f3153b4dfb5', 'c4e96d6b-02b0-5e7b-8d39-9121414f4120', '53fa1958-e53f-53a7-8931-70c9b1c199f4', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '11 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '77b08edc-df7e-5d68-9311-ad505d0a223b', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '18 hours', now() - interval '18 hours'
    from recipes where id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '77b08edc-df7e-5d68-9311-ad505d0a223b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '77b08edc-df7e-5d68-9311-ad505d0a223b', position, body, minutes from recipe_steps where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('c6c2a27e-41ec-56f9-97f7-4efb806b43e0', 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e', '77b08edc-df7e-5d68-9311-ad505d0a223b', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '18 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'e5965c64-4ea4-5e7d-a897-c59aa39109b5', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '79 hours', now() - interval '79 hours'
    from recipes where id = 'a77c7f55-df1d-5e60-9237-26e165f42815'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'e5965c64-4ea4-5e7d-a897-c59aa39109b5', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'e5965c64-4ea4-5e7d-a897-c59aa39109b5', position, body, minutes from recipe_steps where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('49d616f3-d28d-5ffc-981d-6c7d4893f93d', 'a77c7f55-df1d-5e60-9237-26e165f42815', 'e5965c64-4ea4-5e7d-a897-c59aa39109b5', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '79 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '086288d3-4e93-579f-b750-694e49f4856f', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '41 hours', now() - interval '41 hours'
    from recipes where id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '086288d3-4e93-579f-b750-694e49f4856f', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '086288d3-4e93-579f-b750-694e49f4856f', position, body, minutes from recipe_steps where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('bd579613-ed53-5c8b-9e72-29b933245589', '68fd660b-26ef-59f1-b3e2-ed6dee544fa5', '086288d3-4e93-579f-b750-694e49f4856f', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '41 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'cb74165d-1a2a-5de3-a2e5-9010d62823d2', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '15 hours', now() - interval '15 hours'
    from recipes where id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'cb74165d-1a2a-5de3-a2e5-9010d62823d2', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'cb74165d-1a2a-5de3-a2e5-9010d62823d2', position, body, minutes from recipe_steps where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('0ee927c2-fab4-5069-a573-8d1cb777682a', '849520c0-e1e5-5dfd-a8c9-b7f79252267e', 'cb74165d-1a2a-5de3-a2e5-9010d62823d2', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '15 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '19d25729-6ecf-5ae3-a27a-4a4c824f080e', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '9 hours', now() - interval '9 hours'
    from recipes where id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '19d25729-6ecf-5ae3-a27a-4a4c824f080e', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '19d25729-6ecf-5ae3-a27a-4a4c824f080e', position, body, minutes from recipe_steps where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('39d62600-e3be-55e1-a5ee-5c8f8a576baa', 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8', '19d25729-6ecf-5ae3-a27a-4a4c824f080e', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '9 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'cffdcc41-a100-54ea-9d8f-14fb4ae13a94', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '21 hours', now() - interval '21 hours'
    from recipes where id = '23b1127c-bbcb-5318-af9d-53f178823322'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'cffdcc41-a100-54ea-9d8f-14fb4ae13a94', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'cffdcc41-a100-54ea-9d8f-14fb4ae13a94', position, body, minutes from recipe_steps where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('e236af0d-0990-599b-9d01-674ba29861dd', '23b1127c-bbcb-5318-af9d-53f178823322', 'cffdcc41-a100-54ea-9d8f-14fb4ae13a94', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '21 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '0acf51e6-b36f-539a-a146-7940cbc1684b', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '543 hours', now() - interval '543 hours'
    from recipes where id = '20c30394-3ba0-5d43-bd82-ae88bedb9f7b'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '0acf51e6-b36f-539a-a146-7940cbc1684b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '20c30394-3ba0-5d43-bd82-ae88bedb9f7b' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '0acf51e6-b36f-539a-a146-7940cbc1684b', position, body, minutes from recipe_steps where recipe_id = '20c30394-3ba0-5d43-bd82-ae88bedb9f7b' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('70366c31-6e3a-58c8-a337-666ec0a3d18a', '20c30394-3ba0-5d43-bd82-ae88bedb9f7b', '0acf51e6-b36f-539a-a146-7940cbc1684b', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '543 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '82f9d1b6-3a0c-50a6-a73c-8d94b9e81206', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '20 hours', now() - interval '20 hours'
    from recipes where id = 'b26e2e92-6776-5fac-9830-bd9c03a41603'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '82f9d1b6-3a0c-50a6-a73c-8d94b9e81206', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'b26e2e92-6776-5fac-9830-bd9c03a41603' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '82f9d1b6-3a0c-50a6-a73c-8d94b9e81206', position, body, minutes from recipe_steps where recipe_id = 'b26e2e92-6776-5fac-9830-bd9c03a41603' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('baed94dc-5ea5-5a99-9c96-9801c778a7b1', 'b26e2e92-6776-5fac-9830-bd9c03a41603', '82f9d1b6-3a0c-50a6-a73c-8d94b9e81206', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '20 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '78dccc92-d68e-58f3-bfee-3a8765eb2df5', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '472 hours', now() - interval '472 hours'
    from recipes where id = '0d52ad0d-13b8-5c84-9cc6-7ae2491a13b8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '78dccc92-d68e-58f3-bfee-3a8765eb2df5', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '0d52ad0d-13b8-5c84-9cc6-7ae2491a13b8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '78dccc92-d68e-58f3-bfee-3a8765eb2df5', position, body, minutes from recipe_steps where recipe_id = '0d52ad0d-13b8-5c84-9cc6-7ae2491a13b8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('6eb98e1a-0d01-5214-b686-c2f8bc0d4620', '0d52ad0d-13b8-5c84-9cc6-7ae2491a13b8', '78dccc92-d68e-58f3-bfee-3a8765eb2df5', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '472 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '21e2274f-9fe4-5e68-b581-327faafff27e', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '86 hours', now() - interval '86 hours'
    from recipes where id = 'be3d695a-e34a-526c-95b7-9bff71521077'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '21e2274f-9fe4-5e68-b581-327faafff27e', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'be3d695a-e34a-526c-95b7-9bff71521077' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '21e2274f-9fe4-5e68-b581-327faafff27e', position, body, minutes from recipe_steps where recipe_id = 'be3d695a-e34a-526c-95b7-9bff71521077' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('ef612a6a-89f9-54ae-a82d-d27d5b78092d', 'be3d695a-e34a-526c-95b7-9bff71521077', '21e2274f-9fe4-5e68-b581-327faafff27e', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '86 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'ae1b2b53-1811-5da6-9881-f4135dc52872', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '274 hours', now() - interval '274 hours'
    from recipes where id = 'a9a57db1-3ca1-5932-8dcf-9f8adedabb4b'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'ae1b2b53-1811-5da6-9881-f4135dc52872', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a9a57db1-3ca1-5932-8dcf-9f8adedabb4b' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'ae1b2b53-1811-5da6-9881-f4135dc52872', position, body, minutes from recipe_steps where recipe_id = 'a9a57db1-3ca1-5932-8dcf-9f8adedabb4b' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('1ebe109e-3f43-5be3-93ba-78218d367e27', 'a9a57db1-3ca1-5932-8dcf-9f8adedabb4b', 'ae1b2b53-1811-5da6-9881-f4135dc52872', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '274 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'f28ddb01-e428-5758-b1ca-aed251ebc4c0', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '8 hours', now() - interval '8 hours'
    from recipes where id = '002006fb-0bdb-5063-b3ca-ff1e916b1fa6'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'f28ddb01-e428-5758-b1ca-aed251ebc4c0', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '002006fb-0bdb-5063-b3ca-ff1e916b1fa6' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'f28ddb01-e428-5758-b1ca-aed251ebc4c0', position, body, minutes from recipe_steps where recipe_id = '002006fb-0bdb-5063-b3ca-ff1e916b1fa6' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('04cfec3b-6411-59c7-ac4b-6e57a8910209', '002006fb-0bdb-5063-b3ca-ff1e916b1fa6', 'f28ddb01-e428-5758-b1ca-aed251ebc4c0', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '8 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '2a37a10f-2f05-5e74-94a3-0938b5f7514f', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '7 hours', now() - interval '7 hours'
    from recipes where id = '30e36e9c-eed2-5086-a9fe-2122dfbe137f'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '2a37a10f-2f05-5e74-94a3-0938b5f7514f', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '30e36e9c-eed2-5086-a9fe-2122dfbe137f' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '2a37a10f-2f05-5e74-94a3-0938b5f7514f', position, body, minutes from recipe_steps where recipe_id = '30e36e9c-eed2-5086-a9fe-2122dfbe137f' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('6634b1c7-4df6-50b5-9f8e-56bd4065ac09', '30e36e9c-eed2-5086-a9fe-2122dfbe137f', '2a37a10f-2f05-5e74-94a3-0938b5f7514f', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '7 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '00c68270-0753-5fb8-9f85-5e2b820f18a1', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '34 hours', now() - interval '34 hours'
    from recipes where id = '7e84f136-9a8b-5c0e-9070-315a3edd3fb2'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '00c68270-0753-5fb8-9f85-5e2b820f18a1', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '7e84f136-9a8b-5c0e-9070-315a3edd3fb2' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '00c68270-0753-5fb8-9f85-5e2b820f18a1', position, body, minutes from recipe_steps where recipe_id = '7e84f136-9a8b-5c0e-9070-315a3edd3fb2' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('02e24f6c-2aad-5226-96a4-9b28d9aba0b3', '7e84f136-9a8b-5c0e-9070-315a3edd3fb2', '00c68270-0753-5fb8-9f85-5e2b820f18a1', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '34 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '3e529c02-8559-54b5-a42c-24e6a3219489', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '8 hours', now() - interval '8 hours'
    from recipes where id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '3e529c02-8559-54b5-a42c-24e6a3219489', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '3e529c02-8559-54b5-a42c-24e6a3219489', position, body, minutes from recipe_steps where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('de4c79af-bcf9-5bab-8199-681d114dbfe2', 'c4e96d6b-02b0-5e7b-8d39-9121414f4120', '3e529c02-8559-54b5-a42c-24e6a3219489', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '8 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '36e70baf-6508-5a61-b9f1-b64a6b4bddf8', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '7 hours', now() - interval '7 hours'
    from recipes where id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '36e70baf-6508-5a61-b9f1-b64a6b4bddf8', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '36e70baf-6508-5a61-b9f1-b64a6b4bddf8', position, body, minutes from recipe_steps where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('5eb3cc71-93e8-5aa3-b5fa-5fdb4159b4b2', 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e', '36e70baf-6508-5a61-b9f1-b64a6b4bddf8', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '7 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'adbf636e-af27-5e98-834a-81de7caff336', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '67 hours', now() - interval '67 hours'
    from recipes where id = 'a77c7f55-df1d-5e60-9237-26e165f42815'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'adbf636e-af27-5e98-834a-81de7caff336', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'adbf636e-af27-5e98-834a-81de7caff336', position, body, minutes from recipe_steps where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('f9303c7d-eafd-5e45-90a6-33bad9e3bee9', 'a77c7f55-df1d-5e60-9237-26e165f42815', 'adbf636e-af27-5e98-834a-81de7caff336', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '67 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'a5e9a11d-64ae-5cda-9d82-48e7bec49a97', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '53 hours', now() - interval '53 hours'
    from recipes where id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'a5e9a11d-64ae-5cda-9d82-48e7bec49a97', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'a5e9a11d-64ae-5cda-9d82-48e7bec49a97', position, body, minutes from recipe_steps where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('2b153be8-943b-5b9d-a81c-433e28e1ff39', '68fd660b-26ef-59f1-b3e2-ed6dee544fa5', 'a5e9a11d-64ae-5cda-9d82-48e7bec49a97', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '53 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '0e2190f3-b644-5a66-afe6-a0264a403b30', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '96 hours', now() - interval '96 hours'
    from recipes where id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '0e2190f3-b644-5a66-afe6-a0264a403b30', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '0e2190f3-b644-5a66-afe6-a0264a403b30', position, body, minutes from recipe_steps where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('e02a1623-e566-5582-a36d-6a07b738e0a0', '849520c0-e1e5-5dfd-a8c9-b7f79252267e', '0e2190f3-b644-5a66-afe6-a0264a403b30', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '96 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '33661cbb-0951-566b-b514-49518580ab51', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '38 hours', now() - interval '38 hours'
    from recipes where id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '33661cbb-0951-566b-b514-49518580ab51', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '33661cbb-0951-566b-b514-49518580ab51', position, body, minutes from recipe_steps where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('33f19206-46d9-5b0d-9968-6edc9631dbc4', 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8', '33661cbb-0951-566b-b514-49518580ab51', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '38 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'c2e3a420-83e6-5520-b843-960b9d850a29', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '16 hours', now() - interval '16 hours'
    from recipes where id = '23b1127c-bbcb-5318-af9d-53f178823322'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'c2e3a420-83e6-5520-b843-960b9d850a29', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'c2e3a420-83e6-5520-b843-960b9d850a29', position, body, minutes from recipe_steps where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('cf11a091-ae1e-57d1-8671-4497db25c8a5', '23b1127c-bbcb-5318-af9d-53f178823322', 'c2e3a420-83e6-5520-b843-960b9d850a29', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '16 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '023a8171-7e6a-5341-ae05-8edb026d7fd2', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '43 hours', now() - interval '43 hours'
    from recipes where id = 'fe0f442f-9ba3-5d11-9c4b-7f539fa7c9d1'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '023a8171-7e6a-5341-ae05-8edb026d7fd2', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'fe0f442f-9ba3-5d11-9c4b-7f539fa7c9d1' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '023a8171-7e6a-5341-ae05-8edb026d7fd2', position, body, minutes from recipe_steps where recipe_id = 'fe0f442f-9ba3-5d11-9c4b-7f539fa7c9d1' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('89594651-74d7-55d5-bfca-14b0e014db6a', 'fe0f442f-9ba3-5d11-9c4b-7f539fa7c9d1', '023a8171-7e6a-5341-ae05-8edb026d7fd2', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '43 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'e2e10a20-2403-5bee-b0e6-05f6af58707d', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '99 hours', now() - interval '99 hours'
    from recipes where id = '249f538e-8f20-562a-9dff-5118942deebc'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'e2e10a20-2403-5bee-b0e6-05f6af58707d', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '249f538e-8f20-562a-9dff-5118942deebc' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'e2e10a20-2403-5bee-b0e6-05f6af58707d', position, body, minutes from recipe_steps where recipe_id = '249f538e-8f20-562a-9dff-5118942deebc' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b28b7e87-e8c0-5d98-bb87-5e6e79324a59', '249f538e-8f20-562a-9dff-5118942deebc', 'e2e10a20-2403-5bee-b0e6-05f6af58707d', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '99 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '1adb3c49-5f13-5812-8e36-5227f0768061', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '381 hours', now() - interval '381 hours'
    from recipes where id = '7299c134-7ed3-5058-be8b-00a44f7e65c4'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '1adb3c49-5f13-5812-8e36-5227f0768061', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '7299c134-7ed3-5058-be8b-00a44f7e65c4' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '1adb3c49-5f13-5812-8e36-5227f0768061', position, body, minutes from recipe_steps where recipe_id = '7299c134-7ed3-5058-be8b-00a44f7e65c4' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('5d8f6851-ec13-5207-bd13-874d14753415', '7299c134-7ed3-5058-be8b-00a44f7e65c4', '1adb3c49-5f13-5812-8e36-5227f0768061', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '381 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '9a5a977e-0e59-52ea-9c09-080093cfc43c', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '178 hours', now() - interval '178 hours'
    from recipes where id = '9e603613-0733-517a-9529-b2916d2e315f'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '9a5a977e-0e59-52ea-9c09-080093cfc43c', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '9e603613-0733-517a-9529-b2916d2e315f' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '9a5a977e-0e59-52ea-9c09-080093cfc43c', position, body, minutes from recipe_steps where recipe_id = '9e603613-0733-517a-9529-b2916d2e315f' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b4b35b04-28cb-56f7-917f-762d806ade0d', '9e603613-0733-517a-9529-b2916d2e315f', '9a5a977e-0e59-52ea-9c09-080093cfc43c', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '178 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '4b64bbd0-e2d3-5a30-a538-65f5e4d84948', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '7 hours', now() - interval '7 hours'
    from recipes where id = 'a5a13eeb-322f-5e93-83e5-e8afa012a4fa'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '4b64bbd0-e2d3-5a30-a538-65f5e4d84948', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a5a13eeb-322f-5e93-83e5-e8afa012a4fa' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '4b64bbd0-e2d3-5a30-a538-65f5e4d84948', position, body, minutes from recipe_steps where recipe_id = 'a5a13eeb-322f-5e93-83e5-e8afa012a4fa' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('942f9d46-709b-54b5-b4d5-7126230600e7', 'a5a13eeb-322f-5e93-83e5-e8afa012a4fa', '4b64bbd0-e2d3-5a30-a538-65f5e4d84948', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '7 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '4038ef74-ac8a-5b39-858e-f82dd0fb9c57', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '649 hours', now() - interval '649 hours'
    from recipes where id = '68de4cd9-81ff-5f6e-991b-99a46517a57e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '4038ef74-ac8a-5b39-858e-f82dd0fb9c57', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '68de4cd9-81ff-5f6e-991b-99a46517a57e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '4038ef74-ac8a-5b39-858e-f82dd0fb9c57', position, body, minutes from recipe_steps where recipe_id = '68de4cd9-81ff-5f6e-991b-99a46517a57e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('18a51356-1329-52cd-aa1b-5b08441c43ba', '68de4cd9-81ff-5f6e-991b-99a46517a57e', '4038ef74-ac8a-5b39-858e-f82dd0fb9c57', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '649 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '284b45b6-0769-5a1b-b254-1a3654ccb5ca', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '8 hours', now() - interval '8 hours'
    from recipes where id = '458fd498-617d-5f2f-ba13-dc6fb7970d7d'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '284b45b6-0769-5a1b-b254-1a3654ccb5ca', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '458fd498-617d-5f2f-ba13-dc6fb7970d7d' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '284b45b6-0769-5a1b-b254-1a3654ccb5ca', position, body, minutes from recipe_steps where recipe_id = '458fd498-617d-5f2f-ba13-dc6fb7970d7d' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('f91ed469-aad2-54cb-b160-d290d9b83aa1', '458fd498-617d-5f2f-ba13-dc6fb7970d7d', '284b45b6-0769-5a1b-b254-1a3654ccb5ca', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '8 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '6bf74625-bc92-5025-b316-e18ad74396bf', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '119 hours', now() - interval '119 hours'
    from recipes where id = '7c59ff20-1afc-5a0b-bcdb-d8cc9e2815e5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '6bf74625-bc92-5025-b316-e18ad74396bf', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '7c59ff20-1afc-5a0b-bcdb-d8cc9e2815e5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '6bf74625-bc92-5025-b316-e18ad74396bf', position, body, minutes from recipe_steps where recipe_id = '7c59ff20-1afc-5a0b-bcdb-d8cc9e2815e5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('7a9a6a65-85c3-51bd-9c01-9262f41ad471', '7c59ff20-1afc-5a0b-bcdb-d8cc9e2815e5', '6bf74625-bc92-5025-b316-e18ad74396bf', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '119 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '0d4423f6-7385-5c86-b7d1-39d918981f8f', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '51 hours', now() - interval '51 hours'
    from recipes where id = 'ae09b5f5-1d43-5b6a-b8a9-3156deec04b7'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '0d4423f6-7385-5c86-b7d1-39d918981f8f', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'ae09b5f5-1d43-5b6a-b8a9-3156deec04b7' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '0d4423f6-7385-5c86-b7d1-39d918981f8f', position, body, minutes from recipe_steps where recipe_id = 'ae09b5f5-1d43-5b6a-b8a9-3156deec04b7' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('9745400d-3dab-550f-81a3-ed7346746d8a', 'ae09b5f5-1d43-5b6a-b8a9-3156deec04b7', '0d4423f6-7385-5c86-b7d1-39d918981f8f', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '51 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '8d9088d5-8b05-5ad4-948e-a6e370a18366', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '295 hours', now() - interval '295 hours'
    from recipes where id = '3b787e4e-025e-557b-b21d-f3bdf2a30667'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '8d9088d5-8b05-5ad4-948e-a6e370a18366', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '3b787e4e-025e-557b-b21d-f3bdf2a30667' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '8d9088d5-8b05-5ad4-948e-a6e370a18366', position, body, minutes from recipe_steps where recipe_id = '3b787e4e-025e-557b-b21d-f3bdf2a30667' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('dd7716af-9d0e-59ef-a3a9-240190c1e380', '3b787e4e-025e-557b-b21d-f3bdf2a30667', '8d9088d5-8b05-5ad4-948e-a6e370a18366', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '295 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '88167d32-fa1c-59db-8b1d-7af9b7d2d60f', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '44 hours', now() - interval '44 hours'
    from recipes where id = '6e5e28d2-2f5c-5bad-92cb-1c7b085fd10b'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '88167d32-fa1c-59db-8b1d-7af9b7d2d60f', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '6e5e28d2-2f5c-5bad-92cb-1c7b085fd10b' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '88167d32-fa1c-59db-8b1d-7af9b7d2d60f', position, body, minutes from recipe_steps where recipe_id = '6e5e28d2-2f5c-5bad-92cb-1c7b085fd10b' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('f412d275-5606-56d9-98ae-494dc2f49f6a', '6e5e28d2-2f5c-5bad-92cb-1c7b085fd10b', '88167d32-fa1c-59db-8b1d-7af9b7d2d60f', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '44 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'dd8f4eff-8bad-5c52-a129-85e851dfd765', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '444 hours', now() - interval '444 hours'
    from recipes where id = '571d117d-b449-5d18-84dc-c65e10f75e53'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'dd8f4eff-8bad-5c52-a129-85e851dfd765', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '571d117d-b449-5d18-84dc-c65e10f75e53' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'dd8f4eff-8bad-5c52-a129-85e851dfd765', position, body, minutes from recipe_steps where recipe_id = '571d117d-b449-5d18-84dc-c65e10f75e53' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('1ba8b7b9-3cad-5e37-9e68-7167de92cc28', '571d117d-b449-5d18-84dc-c65e10f75e53', 'dd8f4eff-8bad-5c52-a129-85e851dfd765', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '444 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'db010ff8-fd36-535c-b80a-c9916b7c3d70', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '161 hours', now() - interval '161 hours'
    from recipes where id = '50cdf310-6a28-5fed-b78b-09f42796b262'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'db010ff8-fd36-535c-b80a-c9916b7c3d70', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '50cdf310-6a28-5fed-b78b-09f42796b262' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'db010ff8-fd36-535c-b80a-c9916b7c3d70', position, body, minutes from recipe_steps where recipe_id = '50cdf310-6a28-5fed-b78b-09f42796b262' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('d39ed4c1-0e78-52ad-a9b9-d8977a27d460', '50cdf310-6a28-5fed-b78b-09f42796b262', 'db010ff8-fd36-535c-b80a-c9916b7c3d70', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '161 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '568c0a52-609f-52da-82c8-369dff8987dc', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '18 hours', now() - interval '18 hours'
    from recipes where id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '568c0a52-609f-52da-82c8-369dff8987dc', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '568c0a52-609f-52da-82c8-369dff8987dc', position, body, minutes from recipe_steps where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b082df7f-2e6c-5a72-b4eb-f6994d972679', 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e', '568c0a52-609f-52da-82c8-369dff8987dc', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '18 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '00622415-6996-51cb-b6d8-e2b1412b7483', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '19 hours', now() - interval '19 hours'
    from recipes where id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '00622415-6996-51cb-b6d8-e2b1412b7483', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '00622415-6996-51cb-b6d8-e2b1412b7483', position, body, minutes from recipe_steps where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('4889a144-ae7d-57c5-9a38-62ab2293e1ac', '68fd660b-26ef-59f1-b3e2-ed6dee544fa5', '00622415-6996-51cb-b6d8-e2b1412b7483', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '19 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '1268b4d3-9486-5864-b063-1ccfcd443e3e', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '14 hours', now() - interval '14 hours'
    from recipes where id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '1268b4d3-9486-5864-b063-1ccfcd443e3e', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '1268b4d3-9486-5864-b063-1ccfcd443e3e', position, body, minutes from recipe_steps where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('f358f26a-cf56-5ccc-9f9c-b530e8ac04f8', '849520c0-e1e5-5dfd-a8c9-b7f79252267e', '1268b4d3-9486-5864-b063-1ccfcd443e3e', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '14 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'c3dd4305-6cb7-56fb-8dc4-16cacf111c14', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '67 hours', now() - interval '67 hours'
    from recipes where id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'c3dd4305-6cb7-56fb-8dc4-16cacf111c14', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'c3dd4305-6cb7-56fb-8dc4-16cacf111c14', position, body, minutes from recipe_steps where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('40ca90f0-d028-5c21-96fb-3f257a89b615', 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8', 'c3dd4305-6cb7-56fb-8dc4-16cacf111c14', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '67 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'e87e468e-a1f2-518d-9da7-70d5a9f46a18', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '69 hours', now() - interval '69 hours'
    from recipes where id = '23b1127c-bbcb-5318-af9d-53f178823322'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'e87e468e-a1f2-518d-9da7-70d5a9f46a18', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'e87e468e-a1f2-518d-9da7-70d5a9f46a18', position, body, minutes from recipe_steps where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('ca700b6e-f7bc-5c60-9e70-83bb2868f44f', '23b1127c-bbcb-5318-af9d-53f178823322', 'e87e468e-a1f2-518d-9da7-70d5a9f46a18', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '69 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '2b7d3330-69eb-5dcc-b7f2-d68c7d29c192', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '4 hours', now() - interval '4 hours'
    from recipes where id = '358c106e-2890-5567-84bf-e3769768bc09'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '2b7d3330-69eb-5dcc-b7f2-d68c7d29c192', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '358c106e-2890-5567-84bf-e3769768bc09' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '2b7d3330-69eb-5dcc-b7f2-d68c7d29c192', position, body, minutes from recipe_steps where recipe_id = '358c106e-2890-5567-84bf-e3769768bc09' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b56f47ff-a698-5311-93a0-bc28a01c6c75', '358c106e-2890-5567-84bf-e3769768bc09', '2b7d3330-69eb-5dcc-b7f2-d68c7d29c192', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '4 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'fca13f15-655f-5e70-9767-af901013b8d4', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '611 hours', now() - interval '611 hours'
    from recipes where id = '225cfaf3-d9f6-5a68-a65c-d33b6e5a34a0'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'fca13f15-655f-5e70-9767-af901013b8d4', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '225cfaf3-d9f6-5a68-a65c-d33b6e5a34a0' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'fca13f15-655f-5e70-9767-af901013b8d4', position, body, minutes from recipe_steps where recipe_id = '225cfaf3-d9f6-5a68-a65c-d33b6e5a34a0' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('433a0754-9496-5b5a-b874-6b4194e15a84', '225cfaf3-d9f6-5a68-a65c-d33b6e5a34a0', 'fca13f15-655f-5e70-9767-af901013b8d4', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '611 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '70d3f643-cb1a-5902-98e8-71b0e6ac5de1', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '321 hours', now() - interval '321 hours'
    from recipes where id = 'c00b75ac-bb95-54dc-9c5b-3488c217acac'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '70d3f643-cb1a-5902-98e8-71b0e6ac5de1', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c00b75ac-bb95-54dc-9c5b-3488c217acac' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '70d3f643-cb1a-5902-98e8-71b0e6ac5de1', position, body, minutes from recipe_steps where recipe_id = 'c00b75ac-bb95-54dc-9c5b-3488c217acac' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('0f8b8a3b-8e18-5c33-acb8-5587a9c42084', 'c00b75ac-bb95-54dc-9c5b-3488c217acac', '70d3f643-cb1a-5902-98e8-71b0e6ac5de1', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '321 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '045e3b94-3097-5429-a8e0-697b7345b28b', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '52 hours', now() - interval '52 hours'
    from recipes where id = '28517484-31b6-5c98-a626-48ae4a6be9cc'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '045e3b94-3097-5429-a8e0-697b7345b28b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '28517484-31b6-5c98-a626-48ae4a6be9cc' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '045e3b94-3097-5429-a8e0-697b7345b28b', position, body, minutes from recipe_steps where recipe_id = '28517484-31b6-5c98-a626-48ae4a6be9cc' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('25a28f6b-3e06-517d-9d04-b88a7dbb9f01', '28517484-31b6-5c98-a626-48ae4a6be9cc', '045e3b94-3097-5429-a8e0-697b7345b28b', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '52 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '82d38e98-1d4f-508f-91de-076d0f18ffbd', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '2 hours', now() - interval '2 hours'
    from recipes where id = '5fc0263d-e710-5c33-ae2d-2e954def6330'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '82d38e98-1d4f-508f-91de-076d0f18ffbd', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '5fc0263d-e710-5c33-ae2d-2e954def6330' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '82d38e98-1d4f-508f-91de-076d0f18ffbd', position, body, minutes from recipe_steps where recipe_id = '5fc0263d-e710-5c33-ae2d-2e954def6330' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('74e67388-a6de-5099-a4a9-26f97c1707fd', '5fc0263d-e710-5c33-ae2d-2e954def6330', '82d38e98-1d4f-508f-91de-076d0f18ffbd', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '2 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'ecc74cf6-084f-51e1-ad87-109f23adfc77', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '6 hours', now() - interval '6 hours'
    from recipes where id = 'be3071e8-0e70-5abd-8b1f-aedb6fbb390c'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'ecc74cf6-084f-51e1-ad87-109f23adfc77', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'be3071e8-0e70-5abd-8b1f-aedb6fbb390c' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'ecc74cf6-084f-51e1-ad87-109f23adfc77', position, body, minutes from recipe_steps where recipe_id = 'be3071e8-0e70-5abd-8b1f-aedb6fbb390c' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b4a92b99-262a-5485-9ab5-72ae13abf0d2', 'be3071e8-0e70-5abd-8b1f-aedb6fbb390c', 'ecc74cf6-084f-51e1-ad87-109f23adfc77', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '6 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'b90d87aa-e3b2-5693-af84-c980b62c69a8', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '194 hours', now() - interval '194 hours'
    from recipes where id = '9aacd3a3-bc75-5020-b109-b4090f5ee503'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'b90d87aa-e3b2-5693-af84-c980b62c69a8', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '9aacd3a3-bc75-5020-b109-b4090f5ee503' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'b90d87aa-e3b2-5693-af84-c980b62c69a8', position, body, minutes from recipe_steps where recipe_id = '9aacd3a3-bc75-5020-b109-b4090f5ee503' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('dd79f113-4988-5d81-aa27-12b155772e26', '9aacd3a3-bc75-5020-b109-b4090f5ee503', 'b90d87aa-e3b2-5693-af84-c980b62c69a8', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '194 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '1b5c3705-06d6-556d-be93-c7930acddae0', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '3 hours', now() - interval '3 hours'
    from recipes where id = '658f60c6-6cbc-5054-a99b-767e9ea65eb0'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '1b5c3705-06d6-556d-be93-c7930acddae0', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '658f60c6-6cbc-5054-a99b-767e9ea65eb0' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '1b5c3705-06d6-556d-be93-c7930acddae0', position, body, minutes from recipe_steps where recipe_id = '658f60c6-6cbc-5054-a99b-767e9ea65eb0' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('4c3becc4-54ad-57b2-b5d7-d6abefb5dd5f', '658f60c6-6cbc-5054-a99b-767e9ea65eb0', '1b5c3705-06d6-556d-be93-c7930acddae0', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '3 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '5c5d85ce-2cf7-5474-bee8-4ce4e4415bdb', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '433 hours', now() - interval '433 hours'
    from recipes where id = 'c12f55ae-90cb-59b8-8149-4e41760d437b'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '5c5d85ce-2cf7-5474-bee8-4ce4e4415bdb', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c12f55ae-90cb-59b8-8149-4e41760d437b' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '5c5d85ce-2cf7-5474-bee8-4ce4e4415bdb', position, body, minutes from recipe_steps where recipe_id = 'c12f55ae-90cb-59b8-8149-4e41760d437b' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('76aa5a3a-90b0-5dd6-850a-f8b8414eafd4', 'c12f55ae-90cb-59b8-8149-4e41760d437b', '5c5d85ce-2cf7-5474-bee8-4ce4e4415bdb', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '433 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '2241a94b-1a32-52f8-8528-59bbe5e88857', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '647 hours', now() - interval '647 hours'
    from recipes where id = 'f2a90160-6b61-5ae3-9b82-4e78c11a8d7c'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '2241a94b-1a32-52f8-8528-59bbe5e88857', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'f2a90160-6b61-5ae3-9b82-4e78c11a8d7c' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '2241a94b-1a32-52f8-8528-59bbe5e88857', position, body, minutes from recipe_steps where recipe_id = 'f2a90160-6b61-5ae3-9b82-4e78c11a8d7c' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('722b9abe-c0af-517e-806d-7eb116fabf5e', 'f2a90160-6b61-5ae3-9b82-4e78c11a8d7c', '2241a94b-1a32-52f8-8528-59bbe5e88857', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '647 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '48254d61-66db-5578-bc68-b8a018a6fdcd', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '256 hours', now() - interval '256 hours'
    from recipes where id = 'e43481a2-d4fa-5187-8585-a3f7d906eaca'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '48254d61-66db-5578-bc68-b8a018a6fdcd', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e43481a2-d4fa-5187-8585-a3f7d906eaca' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '48254d61-66db-5578-bc68-b8a018a6fdcd', position, body, minutes from recipe_steps where recipe_id = 'e43481a2-d4fa-5187-8585-a3f7d906eaca' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('e0ca1a60-a2ab-5678-86e6-aaeab40a92ea', 'e43481a2-d4fa-5187-8585-a3f7d906eaca', '48254d61-66db-5578-bc68-b8a018a6fdcd', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '256 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '8854866d-664c-5d00-8fee-64b14e942461', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '4 hours', now() - interval '4 hours'
    from recipes where id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '8854866d-664c-5d00-8fee-64b14e942461', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '8854866d-664c-5d00-8fee-64b14e942461', position, body, minutes from recipe_steps where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('342d7046-876a-5e13-83ea-2023f9f627a6', 'c4e96d6b-02b0-5e7b-8d39-9121414f4120', '8854866d-664c-5d00-8fee-64b14e942461', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '4 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '9ff1310e-7fc8-5e8e-8ba1-d91c3d525785', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '72 hours', now() - interval '72 hours'
    from recipes where id = 'a77c7f55-df1d-5e60-9237-26e165f42815'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '9ff1310e-7fc8-5e8e-8ba1-d91c3d525785', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '9ff1310e-7fc8-5e8e-8ba1-d91c3d525785', position, body, minutes from recipe_steps where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('60d0412c-e38c-572b-8268-59202b092056', 'a77c7f55-df1d-5e60-9237-26e165f42815', '9ff1310e-7fc8-5e8e-8ba1-d91c3d525785', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '72 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '99805e98-8ad8-5e3c-967a-ab01a6bc1e01', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '7 hours', now() - interval '7 hours'
    from recipes where id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '99805e98-8ad8-5e3c-967a-ab01a6bc1e01', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '99805e98-8ad8-5e3c-967a-ab01a6bc1e01', position, body, minutes from recipe_steps where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('4ad90f2f-0aa9-507c-bc49-fbae792a2855', '68fd660b-26ef-59f1-b3e2-ed6dee544fa5', '99805e98-8ad8-5e3c-967a-ab01a6bc1e01', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '7 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '7d654b30-0a6f-53cb-9793-4f35be63cf36', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '49 hours', now() - interval '49 hours'
    from recipes where id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '7d654b30-0a6f-53cb-9793-4f35be63cf36', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '7d654b30-0a6f-53cb-9793-4f35be63cf36', position, body, minutes from recipe_steps where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('c906d5c0-7768-5a21-8e87-7e5941a652ed', '849520c0-e1e5-5dfd-a8c9-b7f79252267e', '7d654b30-0a6f-53cb-9793-4f35be63cf36', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '49 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '0a9a3f04-7162-5988-8c78-efe097630db3', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '29 hours', now() - interval '29 hours'
    from recipes where id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '0a9a3f04-7162-5988-8c78-efe097630db3', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '0a9a3f04-7162-5988-8c78-efe097630db3', position, body, minutes from recipe_steps where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('49efa66a-6c74-5f38-a295-0b24fc29c84f', 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8', '0a9a3f04-7162-5988-8c78-efe097630db3', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '29 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '57e824b1-050c-5840-a3c4-c9db67079b9d', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '77 hours', now() - interval '77 hours'
    from recipes where id = '23b1127c-bbcb-5318-af9d-53f178823322'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '57e824b1-050c-5840-a3c4-c9db67079b9d', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '57e824b1-050c-5840-a3c4-c9db67079b9d', position, body, minutes from recipe_steps where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('546cba35-51e3-53f9-a216-dff1337adbe1', '23b1127c-bbcb-5318-af9d-53f178823322', '57e824b1-050c-5840-a3c4-c9db67079b9d', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '77 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '69e7cd01-0606-5f5a-bcea-558788b64af6', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '688 hours', now() - interval '688 hours'
    from recipes where id = 'eaca86cb-a5c1-5ec6-98d8-b496237f10cf'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '69e7cd01-0606-5f5a-bcea-558788b64af6', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'eaca86cb-a5c1-5ec6-98d8-b496237f10cf' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '69e7cd01-0606-5f5a-bcea-558788b64af6', position, body, minutes from recipe_steps where recipe_id = 'eaca86cb-a5c1-5ec6-98d8-b496237f10cf' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('0aeba761-7f8a-5496-bba1-8f26c49d6d9b', 'eaca86cb-a5c1-5ec6-98d8-b496237f10cf', '69e7cd01-0606-5f5a-bcea-558788b64af6', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '688 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'c954eef6-f13d-5172-b1f3-9beae85e84dd', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '645 hours', now() - interval '645 hours'
    from recipes where id = '40778c34-0a64-5f96-a392-6eaeb7c66a65'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'c954eef6-f13d-5172-b1f3-9beae85e84dd', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '40778c34-0a64-5f96-a392-6eaeb7c66a65' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'c954eef6-f13d-5172-b1f3-9beae85e84dd', position, body, minutes from recipe_steps where recipe_id = '40778c34-0a64-5f96-a392-6eaeb7c66a65' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('613e2489-f530-59bd-85e0-1421450b5a47', '40778c34-0a64-5f96-a392-6eaeb7c66a65', 'c954eef6-f13d-5172-b1f3-9beae85e84dd', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '645 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'e59deb47-7d23-5631-80bb-a3763fbea45d', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '28 hours', now() - interval '28 hours'
    from recipes where id = '92dbdc3d-ee77-50a4-94f0-ce2cde23a12d'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'e59deb47-7d23-5631-80bb-a3763fbea45d', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '92dbdc3d-ee77-50a4-94f0-ce2cde23a12d' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'e59deb47-7d23-5631-80bb-a3763fbea45d', position, body, minutes from recipe_steps where recipe_id = '92dbdc3d-ee77-50a4-94f0-ce2cde23a12d' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b6c74b19-e1ad-5f98-a545-5b588baefbdb', '92dbdc3d-ee77-50a4-94f0-ce2cde23a12d', 'e59deb47-7d23-5631-80bb-a3763fbea45d', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '28 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'dfc97ece-eacb-59af-add8-d3d3abb4f96d', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '562 hours', now() - interval '562 hours'
    from recipes where id = '6ceb525d-d47f-5b57-8be7-f9b65c2a1ef7'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'dfc97ece-eacb-59af-add8-d3d3abb4f96d', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '6ceb525d-d47f-5b57-8be7-f9b65c2a1ef7' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'dfc97ece-eacb-59af-add8-d3d3abb4f96d', position, body, minutes from recipe_steps where recipe_id = '6ceb525d-d47f-5b57-8be7-f9b65c2a1ef7' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('8e68b783-4c4a-5d6e-81be-b1a6df734db7', '6ceb525d-d47f-5b57-8be7-f9b65c2a1ef7', 'dfc97ece-eacb-59af-add8-d3d3abb4f96d', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '562 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '9b2ef2fe-3bf4-531d-907b-3bd82813a9bb', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '74 hours', now() - interval '74 hours'
    from recipes where id = '18b94020-4bfe-5973-a8dc-a440d1cde344'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '9b2ef2fe-3bf4-531d-907b-3bd82813a9bb', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '18b94020-4bfe-5973-a8dc-a440d1cde344' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '9b2ef2fe-3bf4-531d-907b-3bd82813a9bb', position, body, minutes from recipe_steps where recipe_id = '18b94020-4bfe-5973-a8dc-a440d1cde344' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('f8c63d6c-165e-5a19-8e7e-1d8b0a066963', '18b94020-4bfe-5973-a8dc-a440d1cde344', '9b2ef2fe-3bf4-531d-907b-3bd82813a9bb', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '74 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'd6e0311d-6873-5ec4-90ea-d3208d7356db', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '92 hours', now() - interval '92 hours'
    from recipes where id = '8688cdb9-ea00-507f-b2fe-990093a119c5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'd6e0311d-6873-5ec4-90ea-d3208d7356db', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '8688cdb9-ea00-507f-b2fe-990093a119c5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'd6e0311d-6873-5ec4-90ea-d3208d7356db', position, body, minutes from recipe_steps where recipe_id = '8688cdb9-ea00-507f-b2fe-990093a119c5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('457aca7b-db29-55b0-8917-8428028cc844', '8688cdb9-ea00-507f-b2fe-990093a119c5', 'd6e0311d-6873-5ec4-90ea-d3208d7356db', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '92 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '43e2674b-2374-5a9c-9b4f-7a61b71b310d', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '336 hours', now() - interval '336 hours'
    from recipes where id = 'd2b4f6d5-c2b4-5ce0-ad92-9b3c0145b0f8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '43e2674b-2374-5a9c-9b4f-7a61b71b310d', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'd2b4f6d5-c2b4-5ce0-ad92-9b3c0145b0f8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '43e2674b-2374-5a9c-9b4f-7a61b71b310d', position, body, minutes from recipe_steps where recipe_id = 'd2b4f6d5-c2b4-5ce0-ad92-9b3c0145b0f8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('c79e0255-15d2-5045-9c81-501a45c0d29c', 'd2b4f6d5-c2b4-5ce0-ad92-9b3c0145b0f8', '43e2674b-2374-5a9c-9b4f-7a61b71b310d', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '336 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '7660987d-893a-594e-81ea-750ada0e974f', 'c6512930-0382-50bb-b18a-db918ff78f26', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '71 hours', now() - interval '71 hours'
    from recipes where id = 'c662144e-0b3b-5e94-9d60-5c35ea92c915'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '7660987d-893a-594e-81ea-750ada0e974f', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c662144e-0b3b-5e94-9d60-5c35ea92c915' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '7660987d-893a-594e-81ea-750ada0e974f', position, body, minutes from recipe_steps where recipe_id = 'c662144e-0b3b-5e94-9d60-5c35ea92c915' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('00bb4308-3e44-5103-829e-41d5557a6e9e', 'c662144e-0b3b-5e94-9d60-5c35ea92c915', '7660987d-893a-594e-81ea-750ada0e974f', 'c6512930-0382-50bb-b18a-db918ff78f26', false, now() - interval '71 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '14a5d331-0f7a-5de0-9df8-d204ff292381', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '2 hours', now() - interval '2 hours'
    from recipes where id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '14a5d331-0f7a-5de0-9df8-d204ff292381', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '14a5d331-0f7a-5de0-9df8-d204ff292381', position, body, minutes from recipe_steps where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('09c13c4b-3690-5e76-8753-dccd826401a9', 'c4e96d6b-02b0-5e7b-8d39-9121414f4120', '14a5d331-0f7a-5de0-9df8-d204ff292381', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '2 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '5d484603-54c9-53f6-877f-ee04f86be1a1', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '18 hours', now() - interval '18 hours'
    from recipes where id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '5d484603-54c9-53f6-877f-ee04f86be1a1', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '5d484603-54c9-53f6-877f-ee04f86be1a1', position, body, minutes from recipe_steps where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('661b0319-7b6c-5f47-b353-29d8a170b42f', 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e', '5d484603-54c9-53f6-877f-ee04f86be1a1', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '18 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '9d7aeaaf-e88d-50c5-8890-8e4bde109c82', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '6 hours', now() - interval '6 hours'
    from recipes where id = 'a77c7f55-df1d-5e60-9237-26e165f42815'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '9d7aeaaf-e88d-50c5-8890-8e4bde109c82', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '9d7aeaaf-e88d-50c5-8890-8e4bde109c82', position, body, minutes from recipe_steps where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('906260d9-2c97-5809-b647-866c0da6df8a', 'a77c7f55-df1d-5e60-9237-26e165f42815', '9d7aeaaf-e88d-50c5-8890-8e4bde109c82', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '6 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '41b45020-9446-559d-af41-7ab5a3ae351c', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '12 hours', now() - interval '12 hours'
    from recipes where id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '41b45020-9446-559d-af41-7ab5a3ae351c', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '41b45020-9446-559d-af41-7ab5a3ae351c', position, body, minutes from recipe_steps where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('5dfb0139-7712-560f-94fc-e361979f290f', '68fd660b-26ef-59f1-b3e2-ed6dee544fa5', '41b45020-9446-559d-af41-7ab5a3ae351c', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '12 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '90cfdc7b-a70c-5b6c-852a-324a6cacb22f', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '114 hours', now() - interval '114 hours'
    from recipes where id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '90cfdc7b-a70c-5b6c-852a-324a6cacb22f', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '90cfdc7b-a70c-5b6c-852a-324a6cacb22f', position, body, minutes from recipe_steps where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('37e2500d-7697-50d0-976f-40fccad2b49b', 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8', '90cfdc7b-a70c-5b6c-852a-324a6cacb22f', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '114 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '2ac79511-5453-5657-a779-8cfc3fc74938', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '47 hours', now() - interval '47 hours'
    from recipes where id = '23b1127c-bbcb-5318-af9d-53f178823322'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '2ac79511-5453-5657-a779-8cfc3fc74938', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '2ac79511-5453-5657-a779-8cfc3fc74938', position, body, minutes from recipe_steps where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b4a8d68d-cad0-5b1a-b8dc-8bd2d7abb49b', '23b1127c-bbcb-5318-af9d-53f178823322', '2ac79511-5453-5657-a779-8cfc3fc74938', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '47 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '36fd62d8-e568-5d0c-ad1a-f68acc3f55c1', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '556 hours', now() - interval '556 hours'
    from recipes where id = '36ee8301-db9a-5c8a-9e61-f28e18f0e525'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '36fd62d8-e568-5d0c-ad1a-f68acc3f55c1', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '36ee8301-db9a-5c8a-9e61-f28e18f0e525' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '36fd62d8-e568-5d0c-ad1a-f68acc3f55c1', position, body, minutes from recipe_steps where recipe_id = '36ee8301-db9a-5c8a-9e61-f28e18f0e525' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('d9353295-c349-5de5-9462-3cc7820eb1db', '36ee8301-db9a-5c8a-9e61-f28e18f0e525', '36fd62d8-e568-5d0c-ad1a-f68acc3f55c1', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '556 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '345db075-d8df-5eba-ae95-e9e1c8908573', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '327 hours', now() - interval '327 hours'
    from recipes where id = '64526908-dd1f-551a-b067-ec0c8a209fe1'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '345db075-d8df-5eba-ae95-e9e1c8908573', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '64526908-dd1f-551a-b067-ec0c8a209fe1' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '345db075-d8df-5eba-ae95-e9e1c8908573', position, body, minutes from recipe_steps where recipe_id = '64526908-dd1f-551a-b067-ec0c8a209fe1' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('6e51fae5-8cf6-58b6-93eb-980bdf77c105', '64526908-dd1f-551a-b067-ec0c8a209fe1', '345db075-d8df-5eba-ae95-e9e1c8908573', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '327 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '20aa004b-5751-5f80-b89d-28b62b0e13a9', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '688 hours', now() - interval '688 hours'
    from recipes where id = '613b38e3-6842-5c35-9d2d-b3f96e1860b6'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '20aa004b-5751-5f80-b89d-28b62b0e13a9', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '613b38e3-6842-5c35-9d2d-b3f96e1860b6' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '20aa004b-5751-5f80-b89d-28b62b0e13a9', position, body, minutes from recipe_steps where recipe_id = '613b38e3-6842-5c35-9d2d-b3f96e1860b6' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('9b489b4b-f0d3-5947-baeb-b649514af6a3', '613b38e3-6842-5c35-9d2d-b3f96e1860b6', '20aa004b-5751-5f80-b89d-28b62b0e13a9', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '688 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'b9d0cb56-9fd4-5b95-ac79-7e5ebdd04a54', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '395 hours', now() - interval '395 hours'
    from recipes where id = '5d9b045f-4224-5b6f-9ad0-7929426cb487'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'b9d0cb56-9fd4-5b95-ac79-7e5ebdd04a54', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '5d9b045f-4224-5b6f-9ad0-7929426cb487' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'b9d0cb56-9fd4-5b95-ac79-7e5ebdd04a54', position, body, minutes from recipe_steps where recipe_id = '5d9b045f-4224-5b6f-9ad0-7929426cb487' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('4b4d73b9-be0d-5c27-8716-a55fe75c2b80', '5d9b045f-4224-5b6f-9ad0-7929426cb487', 'b9d0cb56-9fd4-5b95-ac79-7e5ebdd04a54', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '395 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'd9bf8d75-22f9-5f4b-866f-f649684b4f58', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '480 hours', now() - interval '480 hours'
    from recipes where id = 'faa84458-0e45-5c15-9a40-246e02444d68'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'd9bf8d75-22f9-5f4b-866f-f649684b4f58', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'faa84458-0e45-5c15-9a40-246e02444d68' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'd9bf8d75-22f9-5f4b-866f-f649684b4f58', position, body, minutes from recipe_steps where recipe_id = 'faa84458-0e45-5c15-9a40-246e02444d68' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('f721dd3f-faf8-5cd7-86bf-5673dce004e9', 'faa84458-0e45-5c15-9a40-246e02444d68', 'd9bf8d75-22f9-5f4b-866f-f649684b4f58', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '480 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '339e2fe5-c065-5196-befd-7d1bfb4f98bf', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '649 hours', now() - interval '649 hours'
    from recipes where id = '14dae457-061a-5f17-9e18-421a0c7fc1b8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '339e2fe5-c065-5196-befd-7d1bfb4f98bf', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '14dae457-061a-5f17-9e18-421a0c7fc1b8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '339e2fe5-c065-5196-befd-7d1bfb4f98bf', position, body, minutes from recipe_steps where recipe_id = '14dae457-061a-5f17-9e18-421a0c7fc1b8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('12682c43-8cfb-5a8f-a39a-7f24c5c7fe08', '14dae457-061a-5f17-9e18-421a0c7fc1b8', '339e2fe5-c065-5196-befd-7d1bfb4f98bf', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '649 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'adb4028d-847e-5a0f-a700-ab177f7d9113', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '373 hours', now() - interval '373 hours'
    from recipes where id = '9aac2578-a97a-5e25-9b1e-c8f3152e9e12'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'adb4028d-847e-5a0f-a700-ab177f7d9113', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '9aac2578-a97a-5e25-9b1e-c8f3152e9e12' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'adb4028d-847e-5a0f-a700-ab177f7d9113', position, body, minutes from recipe_steps where recipe_id = '9aac2578-a97a-5e25-9b1e-c8f3152e9e12' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('dc846e04-5934-53be-980f-08ade231189a', '9aac2578-a97a-5e25-9b1e-c8f3152e9e12', 'adb4028d-847e-5a0f-a700-ab177f7d9113', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '373 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '69ebd36a-bc67-578e-bf0f-85f6f2ade5c4', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '44 hours', now() - interval '44 hours'
    from recipes where id = '68f82bd7-286b-50b4-852f-022cc6330ba8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '69ebd36a-bc67-578e-bf0f-85f6f2ade5c4', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '68f82bd7-286b-50b4-852f-022cc6330ba8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '69ebd36a-bc67-578e-bf0f-85f6f2ade5c4', position, body, minutes from recipe_steps where recipe_id = '68f82bd7-286b-50b4-852f-022cc6330ba8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('3bab25f4-0452-5a85-8a04-b92ef54e5072', '68f82bd7-286b-50b4-852f-022cc6330ba8', '69ebd36a-bc67-578e-bf0f-85f6f2ade5c4', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '44 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '991de823-34ee-55b7-888c-f1409c509642', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '16 hours', now() - interval '16 hours'
    from recipes where id = '6d1ce0c6-ed33-5b23-89c0-a9c8baa1ce53'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '991de823-34ee-55b7-888c-f1409c509642', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '6d1ce0c6-ed33-5b23-89c0-a9c8baa1ce53' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '991de823-34ee-55b7-888c-f1409c509642', position, body, minutes from recipe_steps where recipe_id = '6d1ce0c6-ed33-5b23-89c0-a9c8baa1ce53' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('755d9b8f-cea6-534e-9554-fd434b921023', '6d1ce0c6-ed33-5b23-89c0-a9c8baa1ce53', '991de823-34ee-55b7-888c-f1409c509642', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '16 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '02762ed6-64a2-5c7c-8101-1f40efbd7fee', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '670 hours', now() - interval '670 hours'
    from recipes where id = 'f2a90160-6b61-5ae3-9b82-4e78c11a8d7c'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '02762ed6-64a2-5c7c-8101-1f40efbd7fee', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'f2a90160-6b61-5ae3-9b82-4e78c11a8d7c' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '02762ed6-64a2-5c7c-8101-1f40efbd7fee', position, body, minutes from recipe_steps where recipe_id = 'f2a90160-6b61-5ae3-9b82-4e78c11a8d7c' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('473f056b-b20e-5d62-b2bd-cfda1924f917', 'f2a90160-6b61-5ae3-9b82-4e78c11a8d7c', '02762ed6-64a2-5c7c-8101-1f40efbd7fee', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '670 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '55b229b0-67e6-5e58-8fbc-42104bd74cd7', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '129 hours', now() - interval '129 hours'
    from recipes where id = '1fea1fff-176f-557a-8a18-ead557892273'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '55b229b0-67e6-5e58-8fbc-42104bd74cd7', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '1fea1fff-176f-557a-8a18-ead557892273' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '55b229b0-67e6-5e58-8fbc-42104bd74cd7', position, body, minutes from recipe_steps where recipe_id = '1fea1fff-176f-557a-8a18-ead557892273' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('ed337a55-4e8b-51ae-9b04-d68dc1bae646', '1fea1fff-176f-557a-8a18-ead557892273', '55b229b0-67e6-5e58-8fbc-42104bd74cd7', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '129 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'eb811101-a07c-52a4-b81c-6f8c6561683b', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '157 hours', now() - interval '157 hours'
    from recipes where id = '92dbdc3d-ee77-50a4-94f0-ce2cde23a12d'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'eb811101-a07c-52a4-b81c-6f8c6561683b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '92dbdc3d-ee77-50a4-94f0-ce2cde23a12d' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'eb811101-a07c-52a4-b81c-6f8c6561683b', position, body, minutes from recipe_steps where recipe_id = '92dbdc3d-ee77-50a4-94f0-ce2cde23a12d' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b416b3b6-44b8-5d90-b144-ea08878be849', '92dbdc3d-ee77-50a4-94f0-ce2cde23a12d', 'eb811101-a07c-52a4-b81c-6f8c6561683b', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '157 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '2e27b71b-1eeb-528d-b394-d5c0a72a3173', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '68 hours', now() - interval '68 hours'
    from recipes where id = '70f3c1ef-e137-5e7a-af6e-73e1a9e0a3fe'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '2e27b71b-1eeb-528d-b394-d5c0a72a3173', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '70f3c1ef-e137-5e7a-af6e-73e1a9e0a3fe' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '2e27b71b-1eeb-528d-b394-d5c0a72a3173', position, body, minutes from recipe_steps where recipe_id = '70f3c1ef-e137-5e7a-af6e-73e1a9e0a3fe' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('3a1af68f-7514-5ba4-9abe-7ff6a92ea20d', '70f3c1ef-e137-5e7a-af6e-73e1a9e0a3fe', '2e27b71b-1eeb-528d-b394-d5c0a72a3173', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '68 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '9f47d756-1958-5624-a443-80c847303003', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '7 hours', now() - interval '7 hours'
    from recipes where id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '9f47d756-1958-5624-a443-80c847303003', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '9f47d756-1958-5624-a443-80c847303003', position, body, minutes from recipe_steps where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('644dc169-1452-5bac-a202-6a0995c5caeb', 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e', '9f47d756-1958-5624-a443-80c847303003', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '7 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '74548f92-57ab-5e52-b041-251290cd3b65', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '36 hours', now() - interval '36 hours'
    from recipes where id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '74548f92-57ab-5e52-b041-251290cd3b65', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '74548f92-57ab-5e52-b041-251290cd3b65', position, body, minutes from recipe_steps where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('8e0c2b56-338d-5fbd-98c9-17eda30cfe9f', '68fd660b-26ef-59f1-b3e2-ed6dee544fa5', '74548f92-57ab-5e52-b041-251290cd3b65', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '36 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'f841bad8-7786-56bd-ab55-136a786b5f1e', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '60 hours', now() - interval '60 hours'
    from recipes where id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'f841bad8-7786-56bd-ab55-136a786b5f1e', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'f841bad8-7786-56bd-ab55-136a786b5f1e', position, body, minutes from recipe_steps where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('5427d10d-ced5-5059-b45a-1cdff940662e', '849520c0-e1e5-5dfd-a8c9-b7f79252267e', 'f841bad8-7786-56bd-ab55-136a786b5f1e', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '60 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '037c5e62-ac8f-58ed-848f-26dba4c01522', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '49 hours', now() - interval '49 hours'
    from recipes where id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '037c5e62-ac8f-58ed-848f-26dba4c01522', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '037c5e62-ac8f-58ed-848f-26dba4c01522', position, body, minutes from recipe_steps where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('103117f7-df98-56f3-a495-6479bc589161', 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8', '037c5e62-ac8f-58ed-848f-26dba4c01522', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '49 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '031779da-3db0-55d0-9d1f-160cc42d5c0c', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '99 hours', now() - interval '99 hours'
    from recipes where id = '23b1127c-bbcb-5318-af9d-53f178823322'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '031779da-3db0-55d0-9d1f-160cc42d5c0c', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '031779da-3db0-55d0-9d1f-160cc42d5c0c', position, body, minutes from recipe_steps where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('22cb46f7-af9c-5db2-94dd-7e034607046c', '23b1127c-bbcb-5318-af9d-53f178823322', '031779da-3db0-55d0-9d1f-160cc42d5c0c', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '99 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '6067193c-72e3-54f0-9265-ff67a81d7d0a', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '51 hours', now() - interval '51 hours'
    from recipes where id = '20942200-2a64-58f0-a035-21753802db0a'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '6067193c-72e3-54f0-9265-ff67a81d7d0a', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '20942200-2a64-58f0-a035-21753802db0a' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '6067193c-72e3-54f0-9265-ff67a81d7d0a', position, body, minutes from recipe_steps where recipe_id = '20942200-2a64-58f0-a035-21753802db0a' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('3e4e7aa5-c308-5000-8f04-2547bd7fd246', '20942200-2a64-58f0-a035-21753802db0a', '6067193c-72e3-54f0-9265-ff67a81d7d0a', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '51 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '6e28f444-1106-5513-a74b-fea26d4f7a6d', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '156 hours', now() - interval '156 hours'
    from recipes where id = '32958bd7-0f10-5f79-9785-6a5ce56091c0'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '6e28f444-1106-5513-a74b-fea26d4f7a6d', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '32958bd7-0f10-5f79-9785-6a5ce56091c0' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '6e28f444-1106-5513-a74b-fea26d4f7a6d', position, body, minutes from recipe_steps where recipe_id = '32958bd7-0f10-5f79-9785-6a5ce56091c0' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b601a54f-21cc-54e8-b89c-1bb8f3f35cd3', '32958bd7-0f10-5f79-9785-6a5ce56091c0', '6e28f444-1106-5513-a74b-fea26d4f7a6d', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '156 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '052047a7-500a-555b-9b9e-7b3c34784e3d', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '13 hours', now() - interval '13 hours'
    from recipes where id = 'eb2648e3-5e14-517e-ac58-e608a1c2db37'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '052047a7-500a-555b-9b9e-7b3c34784e3d', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'eb2648e3-5e14-517e-ac58-e608a1c2db37' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '052047a7-500a-555b-9b9e-7b3c34784e3d', position, body, minutes from recipe_steps where recipe_id = 'eb2648e3-5e14-517e-ac58-e608a1c2db37' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('416f2937-cdf5-5cc4-980b-8878d2762539', 'eb2648e3-5e14-517e-ac58-e608a1c2db37', '052047a7-500a-555b-9b9e-7b3c34784e3d', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '13 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'cdfa3a69-991d-5590-924c-eb03fecb416b', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '205 hours', now() - interval '205 hours'
    from recipes where id = '3c57f1a4-a664-545c-a292-b6ca529a1253'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'cdfa3a69-991d-5590-924c-eb03fecb416b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '3c57f1a4-a664-545c-a292-b6ca529a1253' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'cdfa3a69-991d-5590-924c-eb03fecb416b', position, body, minutes from recipe_steps where recipe_id = '3c57f1a4-a664-545c-a292-b6ca529a1253' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('dd4e7eea-b289-5a4d-af94-1ddb559100f1', '3c57f1a4-a664-545c-a292-b6ca529a1253', 'cdfa3a69-991d-5590-924c-eb03fecb416b', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '205 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '701190a5-4d69-57e3-bcb3-3c2178fe28d6', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '232 hours', now() - interval '232 hours'
    from recipes where id = 'ec9ddfd9-185a-543c-b395-b8a9de14a326'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '701190a5-4d69-57e3-bcb3-3c2178fe28d6', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'ec9ddfd9-185a-543c-b395-b8a9de14a326' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '701190a5-4d69-57e3-bcb3-3c2178fe28d6', position, body, minutes from recipe_steps where recipe_id = 'ec9ddfd9-185a-543c-b395-b8a9de14a326' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('382a5943-b4f4-56e6-ba77-8ecb3686f2ef', 'ec9ddfd9-185a-543c-b395-b8a9de14a326', '701190a5-4d69-57e3-bcb3-3c2178fe28d6', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '232 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '8445f953-b250-5264-bb05-817c74820392', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '390 hours', now() - interval '390 hours'
    from recipes where id = 'fd74bf4c-e995-505b-9328-a7d0f36e4807'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '8445f953-b250-5264-bb05-817c74820392', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'fd74bf4c-e995-505b-9328-a7d0f36e4807' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '8445f953-b250-5264-bb05-817c74820392', position, body, minutes from recipe_steps where recipe_id = 'fd74bf4c-e995-505b-9328-a7d0f36e4807' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('3d5214ea-96b3-560a-a5bf-8d901d5a2276', 'fd74bf4c-e995-505b-9328-a7d0f36e4807', '8445f953-b250-5264-bb05-817c74820392', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '390 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'f2d9a8d7-98a1-5bcf-a1f9-7afc33dca887', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '428 hours', now() - interval '428 hours'
    from recipes where id = '134f3999-9bf4-5fa2-85bc-aea62cbf64bb'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'f2d9a8d7-98a1-5bcf-a1f9-7afc33dca887', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '134f3999-9bf4-5fa2-85bc-aea62cbf64bb' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'f2d9a8d7-98a1-5bcf-a1f9-7afc33dca887', position, body, minutes from recipe_steps where recipe_id = '134f3999-9bf4-5fa2-85bc-aea62cbf64bb' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('23c78707-8210-554f-abfd-3ce4d722ce24', '134f3999-9bf4-5fa2-85bc-aea62cbf64bb', 'f2d9a8d7-98a1-5bcf-a1f9-7afc33dca887', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '428 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'b460a853-d208-587b-a16a-732388b89085', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '9 hours', now() - interval '9 hours'
    from recipes where id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'b460a853-d208-587b-a16a-732388b89085', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'b460a853-d208-587b-a16a-732388b89085', position, body, minutes from recipe_steps where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('9f131737-2111-52f3-a73e-b5ce49d31504', 'c4e96d6b-02b0-5e7b-8d39-9121414f4120', 'b460a853-d208-587b-a16a-732388b89085', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '9 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'de969a48-5720-5b2a-85ff-228136181c2f', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '14 hours', now() - interval '14 hours'
    from recipes where id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'de969a48-5720-5b2a-85ff-228136181c2f', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'de969a48-5720-5b2a-85ff-228136181c2f', position, body, minutes from recipe_steps where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('593241a7-709a-5690-8721-beb008075a9a', 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e', 'de969a48-5720-5b2a-85ff-228136181c2f', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '14 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '3e3f9ae1-2001-5458-b085-2692e6420f73', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '49 hours', now() - interval '49 hours'
    from recipes where id = 'a77c7f55-df1d-5e60-9237-26e165f42815'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '3e3f9ae1-2001-5458-b085-2692e6420f73', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '3e3f9ae1-2001-5458-b085-2692e6420f73', position, body, minutes from recipe_steps where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('74e9cd72-ce2c-5db3-a3a7-c61c95c2770e', 'a77c7f55-df1d-5e60-9237-26e165f42815', '3e3f9ae1-2001-5458-b085-2692e6420f73', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '49 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'd559d780-a2a9-52a4-a386-1c345e135e35', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '53 hours', now() - interval '53 hours'
    from recipes where id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'd559d780-a2a9-52a4-a386-1c345e135e35', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'd559d780-a2a9-52a4-a386-1c345e135e35', position, body, minutes from recipe_steps where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('1f5059c5-6fae-59a7-80ce-5bc26b5983ce', '849520c0-e1e5-5dfd-a8c9-b7f79252267e', 'd559d780-a2a9-52a4-a386-1c345e135e35', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '53 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '5a47a50a-b5d1-5d70-8cc0-1be69cde11a5', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '84 hours', now() - interval '84 hours'
    from recipes where id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '5a47a50a-b5d1-5d70-8cc0-1be69cde11a5', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '5a47a50a-b5d1-5d70-8cc0-1be69cde11a5', position, body, minutes from recipe_steps where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('3bb962ba-359a-54a3-9495-fe9e3ab1ca13', 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8', '5a47a50a-b5d1-5d70-8cc0-1be69cde11a5', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '84 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '27d8fdb5-8fd3-5b64-889b-7b776d802bda', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '25 hours', now() - interval '25 hours'
    from recipes where id = '23b1127c-bbcb-5318-af9d-53f178823322'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '27d8fdb5-8fd3-5b64-889b-7b776d802bda', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '27d8fdb5-8fd3-5b64-889b-7b776d802bda', position, body, minutes from recipe_steps where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('33dbdc36-7121-5669-8768-d49dad4c2f2a', '23b1127c-bbcb-5318-af9d-53f178823322', '27d8fdb5-8fd3-5b64-889b-7b776d802bda', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '25 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '78f59bea-7b85-5d1b-88c8-74812df24e43', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '120 hours', now() - interval '120 hours'
    from recipes where id = '9f109dcf-8d72-5192-b68c-ba8617474fd9'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '78f59bea-7b85-5d1b-88c8-74812df24e43', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '9f109dcf-8d72-5192-b68c-ba8617474fd9' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '78f59bea-7b85-5d1b-88c8-74812df24e43', position, body, minutes from recipe_steps where recipe_id = '9f109dcf-8d72-5192-b68c-ba8617474fd9' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('77af8f00-2456-5b48-a39e-280972e61232', '9f109dcf-8d72-5192-b68c-ba8617474fd9', '78f59bea-7b85-5d1b-88c8-74812df24e43', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '120 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'c714d37f-a663-547c-96cb-25d81903111b', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '35 hours', now() - interval '35 hours'
    from recipes where id = '3ec1d2bc-c588-5cca-b111-85bdf184b465'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'c714d37f-a663-547c-96cb-25d81903111b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '3ec1d2bc-c588-5cca-b111-85bdf184b465' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'c714d37f-a663-547c-96cb-25d81903111b', position, body, minutes from recipe_steps where recipe_id = '3ec1d2bc-c588-5cca-b111-85bdf184b465' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('d928d441-954e-5e83-8b41-301f3efbafd8', '3ec1d2bc-c588-5cca-b111-85bdf184b465', 'c714d37f-a663-547c-96cb-25d81903111b', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '35 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '256c8a9f-5d5f-5b14-95c5-197d123c1b5a', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '122 hours', now() - interval '122 hours'
    from recipes where id = '7d9f386c-fd96-57b7-9763-51a932a806ca'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '256c8a9f-5d5f-5b14-95c5-197d123c1b5a', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '7d9f386c-fd96-57b7-9763-51a932a806ca' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '256c8a9f-5d5f-5b14-95c5-197d123c1b5a', position, body, minutes from recipe_steps where recipe_id = '7d9f386c-fd96-57b7-9763-51a932a806ca' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('f0d11c55-22ed-531d-a553-548b4f6eb146', '7d9f386c-fd96-57b7-9763-51a932a806ca', '256c8a9f-5d5f-5b14-95c5-197d123c1b5a', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '122 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '5d15c49e-353c-5a51-b096-154b2d27b701', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '320 hours', now() - interval '320 hours'
    from recipes where id = 'eb8517c3-b20c-5c56-b8e0-c81bd14d7515'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '5d15c49e-353c-5a51-b096-154b2d27b701', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'eb8517c3-b20c-5c56-b8e0-c81bd14d7515' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '5d15c49e-353c-5a51-b096-154b2d27b701', position, body, minutes from recipe_steps where recipe_id = 'eb8517c3-b20c-5c56-b8e0-c81bd14d7515' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('573cd69d-136f-5db3-8b6c-f043f55547e3', 'eb8517c3-b20c-5c56-b8e0-c81bd14d7515', '5d15c49e-353c-5a51-b096-154b2d27b701', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '320 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '0e21d93a-fbaa-5fe6-a58f-8e2ab6270468', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '567 hours', now() - interval '567 hours'
    from recipes where id = '200cb68f-328f-556b-b5c5-fb54d921f964'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '0e21d93a-fbaa-5fe6-a58f-8e2ab6270468', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '200cb68f-328f-556b-b5c5-fb54d921f964' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '0e21d93a-fbaa-5fe6-a58f-8e2ab6270468', position, body, minutes from recipe_steps where recipe_id = '200cb68f-328f-556b-b5c5-fb54d921f964' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('c4a2a5c8-f2bd-549d-9e4f-481fdb69a986', '200cb68f-328f-556b-b5c5-fb54d921f964', '0e21d93a-fbaa-5fe6-a58f-8e2ab6270468', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '567 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'fa7c32c9-6979-5991-8664-0289092a6d1a', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '11 hours', now() - interval '11 hours'
    from recipes where id = '3c500afa-45df-5d61-be7f-ba9dee3e12a4'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'fa7c32c9-6979-5991-8664-0289092a6d1a', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '3c500afa-45df-5d61-be7f-ba9dee3e12a4' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'fa7c32c9-6979-5991-8664-0289092a6d1a', position, body, minutes from recipe_steps where recipe_id = '3c500afa-45df-5d61-be7f-ba9dee3e12a4' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('d46b433b-d2f2-5646-9e9c-153ceb846e48', '3c500afa-45df-5d61-be7f-ba9dee3e12a4', 'fa7c32c9-6979-5991-8664-0289092a6d1a', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '11 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '4e267dae-9e7b-5dc8-aad3-24298d12c905', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '684 hours', now() - interval '684 hours'
    from recipes where id = '9bdca1f9-1670-5bef-993b-9a74e6659eb5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '4e267dae-9e7b-5dc8-aad3-24298d12c905', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '9bdca1f9-1670-5bef-993b-9a74e6659eb5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '4e267dae-9e7b-5dc8-aad3-24298d12c905', position, body, minutes from recipe_steps where recipe_id = '9bdca1f9-1670-5bef-993b-9a74e6659eb5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('7184e775-4ae0-5db8-9981-d8fb5645387b', '9bdca1f9-1670-5bef-993b-9a74e6659eb5', '4e267dae-9e7b-5dc8-aad3-24298d12c905', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '684 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '2da2e239-d043-5811-ae0b-31ddc38ddd3b', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '416 hours', now() - interval '416 hours'
    from recipes where id = 'e699d479-a896-5553-9752-36b63b09f194'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '2da2e239-d043-5811-ae0b-31ddc38ddd3b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e699d479-a896-5553-9752-36b63b09f194' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '2da2e239-d043-5811-ae0b-31ddc38ddd3b', position, body, minutes from recipe_steps where recipe_id = 'e699d479-a896-5553-9752-36b63b09f194' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('c7a6a70b-9794-59a7-aec3-b683dff0f1d4', 'e699d479-a896-5553-9752-36b63b09f194', '2da2e239-d043-5811-ae0b-31ddc38ddd3b', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '416 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '2dc1ef5c-8045-5c35-90f8-f1120d45890e', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '65 hours', now() - interval '65 hours'
    from recipes where id = '26b0eae1-309b-5a61-b9be-f388de74b06f'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '2dc1ef5c-8045-5c35-90f8-f1120d45890e', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '26b0eae1-309b-5a61-b9be-f388de74b06f' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '2dc1ef5c-8045-5c35-90f8-f1120d45890e', position, body, minutes from recipe_steps where recipe_id = '26b0eae1-309b-5a61-b9be-f388de74b06f' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('78261b7d-c681-5d22-9e47-de1ed5235a31', '26b0eae1-309b-5a61-b9be-f388de74b06f', '2dc1ef5c-8045-5c35-90f8-f1120d45890e', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '65 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'b8b4687e-65ff-5ab4-a465-04b9109bc2e4', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '440 hours', now() - interval '440 hours'
    from recipes where id = 'd5d88faf-124a-5925-a05a-0a9ad2ad0830'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'b8b4687e-65ff-5ab4-a465-04b9109bc2e4', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'd5d88faf-124a-5925-a05a-0a9ad2ad0830' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'b8b4687e-65ff-5ab4-a465-04b9109bc2e4', position, body, minutes from recipe_steps where recipe_id = 'd5d88faf-124a-5925-a05a-0a9ad2ad0830' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('4ac103c9-82d5-5e00-ab8c-2efea47240d4', 'd5d88faf-124a-5925-a05a-0a9ad2ad0830', 'b8b4687e-65ff-5ab4-a465-04b9109bc2e4', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '440 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '1e65003c-809e-5e0f-a0fd-f8a11b74aec0', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '13 hours', now() - interval '13 hours'
    from recipes where id = 'c8ea2510-c519-5fea-a858-5b15accf4293'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '1e65003c-809e-5e0f-a0fd-f8a11b74aec0', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c8ea2510-c519-5fea-a858-5b15accf4293' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '1e65003c-809e-5e0f-a0fd-f8a11b74aec0', position, body, minutes from recipe_steps where recipe_id = 'c8ea2510-c519-5fea-a858-5b15accf4293' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('2e614bce-81a0-507c-82ec-fb0f2045746c', 'c8ea2510-c519-5fea-a858-5b15accf4293', '1e65003c-809e-5e0f-a0fd-f8a11b74aec0', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '13 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'adae84fa-705c-5593-91b1-0007a083f891', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '116 hours', now() - interval '116 hours'
    from recipes where id = 'a77c7f55-df1d-5e60-9237-26e165f42815'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'adae84fa-705c-5593-91b1-0007a083f891', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'adae84fa-705c-5593-91b1-0007a083f891', position, body, minutes from recipe_steps where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('4167869a-c7d1-53af-9871-ec417a235077', 'a77c7f55-df1d-5e60-9237-26e165f42815', 'adae84fa-705c-5593-91b1-0007a083f891', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '116 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'c4f4ac16-d541-53b1-a364-952c95cdde2a', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '19 hours', now() - interval '19 hours'
    from recipes where id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'c4f4ac16-d541-53b1-a364-952c95cdde2a', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'c4f4ac16-d541-53b1-a364-952c95cdde2a', position, body, minutes from recipe_steps where recipe_id = '68fd660b-26ef-59f1-b3e2-ed6dee544fa5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('85b83160-c794-50ba-85c8-56d87019131f', '68fd660b-26ef-59f1-b3e2-ed6dee544fa5', 'c4f4ac16-d541-53b1-a364-952c95cdde2a', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '19 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'e6a22207-7de5-5d57-a480-f6d06fc733f7', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '6 hours', now() - interval '6 hours'
    from recipes where id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'e6a22207-7de5-5d57-a480-f6d06fc733f7', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'e6a22207-7de5-5d57-a480-f6d06fc733f7', position, body, minutes from recipe_steps where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('8b15573d-8f3a-596f-ac27-e4c396dda4c0', 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8', 'e6a22207-7de5-5d57-a480-f6d06fc733f7', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '6 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'cd399449-39e9-51a4-a18a-04996d32bfe8', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '50 hours', now() - interval '50 hours'
    from recipes where id = '23b1127c-bbcb-5318-af9d-53f178823322'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'cd399449-39e9-51a4-a18a-04996d32bfe8', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'cd399449-39e9-51a4-a18a-04996d32bfe8', position, body, minutes from recipe_steps where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('5be8b151-d5d0-5040-8b81-82bd2a006710', '23b1127c-bbcb-5318-af9d-53f178823322', 'cd399449-39e9-51a4-a18a-04996d32bfe8', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '50 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'ea58a1f4-4e0e-5322-8033-bd472c2d7650', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '17 hours', now() - interval '17 hours'
    from recipes where id = '6305a24e-d62a-5d08-a013-7469e45f1b8d'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'ea58a1f4-4e0e-5322-8033-bd472c2d7650', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '6305a24e-d62a-5d08-a013-7469e45f1b8d' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'ea58a1f4-4e0e-5322-8033-bd472c2d7650', position, body, minutes from recipe_steps where recipe_id = '6305a24e-d62a-5d08-a013-7469e45f1b8d' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('a46d7c67-0cba-550d-83a5-8f2c5fbba602', '6305a24e-d62a-5d08-a013-7469e45f1b8d', 'ea58a1f4-4e0e-5322-8033-bd472c2d7650', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '17 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'a7c45c87-040c-5bdd-8fb2-5d9d1913d580', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '534 hours', now() - interval '534 hours'
    from recipes where id = '2d4c1a7e-d2db-5a3d-a87d-42e8fa18bfa0'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'a7c45c87-040c-5bdd-8fb2-5d9d1913d580', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '2d4c1a7e-d2db-5a3d-a87d-42e8fa18bfa0' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'a7c45c87-040c-5bdd-8fb2-5d9d1913d580', position, body, minutes from recipe_steps where recipe_id = '2d4c1a7e-d2db-5a3d-a87d-42e8fa18bfa0' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('75f7e18b-1ec4-563a-9f20-08fdaf330071', '2d4c1a7e-d2db-5a3d-a87d-42e8fa18bfa0', 'a7c45c87-040c-5bdd-8fb2-5d9d1913d580', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '534 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '03eeb626-d14d-5c44-827e-837b9af661f6', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '707 hours', now() - interval '707 hours'
    from recipes where id = '21dacc80-a5b1-5886-91a0-c7766475582c'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '03eeb626-d14d-5c44-827e-837b9af661f6', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '21dacc80-a5b1-5886-91a0-c7766475582c' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '03eeb626-d14d-5c44-827e-837b9af661f6', position, body, minutes from recipe_steps where recipe_id = '21dacc80-a5b1-5886-91a0-c7766475582c' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('32e8b9d4-fe07-5fc1-ae32-209dfea9c493', '21dacc80-a5b1-5886-91a0-c7766475582c', '03eeb626-d14d-5c44-827e-837b9af661f6', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '707 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '80bd8e20-ba87-5509-89d7-73b8a7e925a5', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '509 hours', now() - interval '509 hours'
    from recipes where id = 'f5f18418-9578-5ede-b54d-6cb1afa91a48'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '80bd8e20-ba87-5509-89d7-73b8a7e925a5', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'f5f18418-9578-5ede-b54d-6cb1afa91a48' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '80bd8e20-ba87-5509-89d7-73b8a7e925a5', position, body, minutes from recipe_steps where recipe_id = 'f5f18418-9578-5ede-b54d-6cb1afa91a48' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('c896dc98-520d-569c-810a-e62a54c8f158', 'f5f18418-9578-5ede-b54d-6cb1afa91a48', '80bd8e20-ba87-5509-89d7-73b8a7e925a5', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '509 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'e930da96-2184-5649-816c-b9ec7dbf7e80', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '59 hours', now() - interval '59 hours'
    from recipes where id = '15e45a5f-0535-50b6-bd46-638de19bb8b5'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'e930da96-2184-5649-816c-b9ec7dbf7e80', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '15e45a5f-0535-50b6-bd46-638de19bb8b5' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'e930da96-2184-5649-816c-b9ec7dbf7e80', position, body, minutes from recipe_steps where recipe_id = '15e45a5f-0535-50b6-bd46-638de19bb8b5' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('4444d9f9-f1c5-5278-bf61-79156e452dc1', '15e45a5f-0535-50b6-bd46-638de19bb8b5', 'e930da96-2184-5649-816c-b9ec7dbf7e80', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '59 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '031eca94-0d89-5cbe-b32f-545aeccfb130', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '7 hours', now() - interval '7 hours'
    from recipes where id = 'e7bc367a-5091-589f-b597-28df209614a2'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '031eca94-0d89-5cbe-b32f-545aeccfb130', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e7bc367a-5091-589f-b597-28df209614a2' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '031eca94-0d89-5cbe-b32f-545aeccfb130', position, body, minutes from recipe_steps where recipe_id = 'e7bc367a-5091-589f-b597-28df209614a2' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('9f847c4e-a331-590b-a113-99b61fba2313', 'e7bc367a-5091-589f-b597-28df209614a2', '031eca94-0d89-5cbe-b32f-545aeccfb130', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '7 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '957f2a2a-5f37-5f2c-87bd-679d15c8e032', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '560 hours', now() - interval '560 hours'
    from recipes where id = 'c3cf481f-c720-55a2-99ca-7e8edd87033f'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '957f2a2a-5f37-5f2c-87bd-679d15c8e032', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c3cf481f-c720-55a2-99ca-7e8edd87033f' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '957f2a2a-5f37-5f2c-87bd-679d15c8e032', position, body, minutes from recipe_steps where recipe_id = 'c3cf481f-c720-55a2-99ca-7e8edd87033f' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('6d34e8ef-5090-5c09-a070-60597d649827', 'c3cf481f-c720-55a2-99ca-7e8edd87033f', '957f2a2a-5f37-5f2c-87bd-679d15c8e032', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '560 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '5f88a350-6775-5ba8-893e-14768be80738', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '9 hours', now() - interval '9 hours'
    from recipes where id = 'a990ccde-f33e-5e72-b9e8-bc7239a5f618'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '5f88a350-6775-5ba8-893e-14768be80738', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a990ccde-f33e-5e72-b9e8-bc7239a5f618' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '5f88a350-6775-5ba8-893e-14768be80738', position, body, minutes from recipe_steps where recipe_id = 'a990ccde-f33e-5e72-b9e8-bc7239a5f618' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('c52d1a93-98e1-5d4f-b2f5-c19911317075', 'a990ccde-f33e-5e72-b9e8-bc7239a5f618', '5f88a350-6775-5ba8-893e-14768be80738', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '9 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '254da03f-9f2b-5581-ad75-0a1cc1e61c6c', '67c5aecd-680b-5574-aa4c-082784fe7707', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '3 hours', now() - interval '3 hours'
    from recipes where id = '7034ea63-a256-5e1b-8b50-99fde09e8b4b'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '254da03f-9f2b-5581-ad75-0a1cc1e61c6c', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '7034ea63-a256-5e1b-8b50-99fde09e8b4b' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '254da03f-9f2b-5581-ad75-0a1cc1e61c6c', position, body, minutes from recipe_steps where recipe_id = '7034ea63-a256-5e1b-8b50-99fde09e8b4b' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('e01ed89c-1ca4-5a97-8376-c101977fb163', '7034ea63-a256-5e1b-8b50-99fde09e8b4b', '254da03f-9f2b-5581-ad75-0a1cc1e61c6c', '67c5aecd-680b-5574-aa4c-082784fe7707', false, now() - interval '3 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'a75c3c7e-3157-5abf-8c48-b7ecd19b9473', 'ed48de41-79b0-595b-a0cd-984366f827e6', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '2 hours', now() - interval '2 hours'
    from recipes where id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'a75c3c7e-3157-5abf-8c48-b7ecd19b9473', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'a75c3c7e-3157-5abf-8c48-b7ecd19b9473', position, body, minutes from recipe_steps where recipe_id = 'c4e96d6b-02b0-5e7b-8d39-9121414f4120' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('4cadd3e3-a460-57eb-b955-154d478a59a1', 'c4e96d6b-02b0-5e7b-8d39-9121414f4120', 'a75c3c7e-3157-5abf-8c48-b7ecd19b9473', 'ed48de41-79b0-595b-a0cd-984366f827e6', false, now() - interval '2 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'd94f8782-537c-580d-bcc7-cedf227a70b5', 'ed48de41-79b0-595b-a0cd-984366f827e6', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '20 hours', now() - interval '20 hours'
    from recipes where id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'd94f8782-537c-580d-bcc7-cedf227a70b5', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'd94f8782-537c-580d-bcc7-cedf227a70b5', position, body, minutes from recipe_steps where recipe_id = 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('8fe631b3-3cbe-533e-87fe-626ffb576b70', 'e6b0c6a9-8047-5594-9cc6-ab8a81adf56e', 'd94f8782-537c-580d-bcc7-cedf227a70b5', 'ed48de41-79b0-595b-a0cd-984366f827e6', false, now() - interval '20 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '328cff15-e01e-5be0-a93b-1f64f259d576', 'ed48de41-79b0-595b-a0cd-984366f827e6', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'public', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '52 hours', now() - interval '52 hours'
    from recipes where id = 'a77c7f55-df1d-5e60-9237-26e165f42815'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '328cff15-e01e-5be0-a93b-1f64f259d576', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '328cff15-e01e-5be0-a93b-1f64f259d576', position, body, minutes from recipe_steps where recipe_id = 'a77c7f55-df1d-5e60-9237-26e165f42815' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('6454155a-ee35-510e-a8d8-22900abfd0ae', 'a77c7f55-df1d-5e60-9237-26e165f42815', '328cff15-e01e-5be0-a93b-1f64f259d576', 'ed48de41-79b0-595b-a0cd-984366f827e6', false, now() - interval '52 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '9fbb36e0-dd53-5792-9a96-5d76381690c7', 'ed48de41-79b0-595b-a0cd-984366f827e6', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '43 hours', now() - interval '43 hours'
    from recipes where id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '9fbb36e0-dd53-5792-9a96-5d76381690c7', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '9fbb36e0-dd53-5792-9a96-5d76381690c7', position, body, minutes from recipe_steps where recipe_id = '849520c0-e1e5-5dfd-a8c9-b7f79252267e' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('4a7b9062-61d5-58b7-8226-45900aac993b', '849520c0-e1e5-5dfd-a8c9-b7f79252267e', '9fbb36e0-dd53-5792-9a96-5d76381690c7', 'ed48de41-79b0-595b-a0cd-984366f827e6', false, now() - interval '43 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'f7ad4c80-bbf9-5595-a0e9-d9f05eefdf2e', 'ed48de41-79b0-595b-a0cd-984366f827e6', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '9 hours', now() - interval '9 hours'
    from recipes where id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'f7ad4c80-bbf9-5595-a0e9-d9f05eefdf2e', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'f7ad4c80-bbf9-5595-a0e9-d9f05eefdf2e', position, body, minutes from recipe_steps where recipe_id = 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('571632bc-48cf-5622-9d84-1810c64fee43', 'c5cff2b7-781b-55a9-9e5e-9f55a8431bc8', 'f7ad4c80-bbf9-5595-a0e9-d9f05eefdf2e', 'ed48de41-79b0-595b-a0cd-984366f827e6', false, now() - interval '9 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '54814904-13d2-5506-809f-9f0bec1ca187', 'ed48de41-79b0-595b-a0cd-984366f827e6', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '78 hours', now() - interval '78 hours'
    from recipes where id = '23b1127c-bbcb-5318-af9d-53f178823322'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '54814904-13d2-5506-809f-9f0bec1ca187', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '54814904-13d2-5506-809f-9f0bec1ca187', position, body, minutes from recipe_steps where recipe_id = '23b1127c-bbcb-5318-af9d-53f178823322' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('02739006-6fea-52a3-a16e-1cc17cd664e1', '23b1127c-bbcb-5318-af9d-53f178823322', '54814904-13d2-5506-809f-9f0bec1ca187', 'ed48de41-79b0-595b-a0cd-984366f827e6', false, now() - interval '78 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '87326359-5939-5fc2-ab09-b9bdf4c10f02', 'ed48de41-79b0-595b-a0cd-984366f827e6', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '121 hours', now() - interval '121 hours'
    from recipes where id = 'bae96d57-0f29-5223-bd43-8a98804ced00'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '87326359-5939-5fc2-ab09-b9bdf4c10f02', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'bae96d57-0f29-5223-bd43-8a98804ced00' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '87326359-5939-5fc2-ab09-b9bdf4c10f02', position, body, minutes from recipe_steps where recipe_id = 'bae96d57-0f29-5223-bd43-8a98804ced00' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('866331e0-ab38-5a38-abb6-2d52ff8a5221', 'bae96d57-0f29-5223-bd43-8a98804ced00', '87326359-5939-5fc2-ab09-b9bdf4c10f02', 'ed48de41-79b0-595b-a0cd-984366f827e6', false, now() - interval '121 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '43ca27f4-8997-5c6f-8d19-379875d787cf', 'ed48de41-79b0-595b-a0cd-984366f827e6', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'followers', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '459 hours', now() - interval '459 hours'
    from recipes where id = 'c58f2d09-8a99-5b1a-986d-80c41a2af5e7'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '43ca27f4-8997-5c6f-8d19-379875d787cf', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c58f2d09-8a99-5b1a-986d-80c41a2af5e7' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '43ca27f4-8997-5c6f-8d19-379875d787cf', position, body, minutes from recipe_steps where recipe_id = 'c58f2d09-8a99-5b1a-986d-80c41a2af5e7' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('378f4ed8-07f2-53a7-80eb-11626a144f32', 'c58f2d09-8a99-5b1a-986d-80c41a2af5e7', '43ca27f4-8997-5c6f-8d19-379875d787cf', 'ed48de41-79b0-595b-a0cd-984366f827e6', false, now() - interval '459 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '32393383-0dc1-5143-ab7a-87cc31c72dbc', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '52 hours', now() - interval '52 hours'
    from recipes where id = '2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '32393383-0dc1-5143-ab7a-87cc31c72dbc', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '32393383-0dc1-5143-ab7a-87cc31c72dbc', position, body, minutes from recipe_steps where recipe_id = '2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b5ad1c10-bf5e-55f9-b151-717c75822108', '2f59f3dd-baf2-5ac7-9a2a-ab359cdc9773', '32393383-0dc1-5143-ab7a-87cc31c72dbc', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '52 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'ecbbd320-1980-512b-8a5b-1315da1ac83e', '69e35bef-6695-5b4f-89f7-684f67bd404c', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '211 hours', now() - interval '211 hours'
    from recipes where id = '37ea3b45-7834-560c-a16d-347c624ddc91'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'ecbbd320-1980-512b-8a5b-1315da1ac83e', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '37ea3b45-7834-560c-a16d-347c624ddc91' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'ecbbd320-1980-512b-8a5b-1315da1ac83e', position, body, minutes from recipe_steps where recipe_id = '37ea3b45-7834-560c-a16d-347c624ddc91' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('a5509499-3314-59ea-9b11-5c6c41db8e18', '37ea3b45-7834-560c-a16d-347c624ddc91', 'ecbbd320-1980-512b-8a5b-1315da1ac83e', '69e35bef-6695-5b4f-89f7-684f67bd404c', false, now() - interval '211 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '7fffedaa-9f4c-5834-ab04-899cfad02565', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '78 hours', now() - interval '78 hours'
    from recipes where id = 'f4134598-19a8-5684-8ad4-3f26f1c91929'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '7fffedaa-9f4c-5834-ab04-899cfad02565', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'f4134598-19a8-5684-8ad4-3f26f1c91929' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '7fffedaa-9f4c-5834-ab04-899cfad02565', position, body, minutes from recipe_steps where recipe_id = 'f4134598-19a8-5684-8ad4-3f26f1c91929' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('9f8fb6e4-c3b8-524e-ac99-6e3b7c6b5f1a', 'f4134598-19a8-5684-8ad4-3f26f1c91929', '7fffedaa-9f4c-5834-ab04-899cfad02565', 'ed018e6a-4007-5baf-bcf6-ab10a793deec', false, now() - interval '78 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'c19f5a63-813b-57b4-8ff2-2c81c09c9326', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '1 hours', now() - interval '1 hours'
    from recipes where id = '3f0de9c8-e489-54ae-9da1-b4c419f90451'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'c19f5a63-813b-57b4-8ff2-2c81c09c9326', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '3f0de9c8-e489-54ae-9da1-b4c419f90451' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'c19f5a63-813b-57b4-8ff2-2c81c09c9326', position, body, minutes from recipe_steps where recipe_id = '3f0de9c8-e489-54ae-9da1-b4c419f90451' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('6c8a3cb8-4b50-5baf-a187-73c1d5848011', '3f0de9c8-e489-54ae-9da1-b4c419f90451', 'c19f5a63-813b-57b4-8ff2-2c81c09c9326', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '1 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'f8986d3d-2b75-532b-84b1-bf19eda9c736', 'f81498e9-a866-50d7-a546-e0792b54c0c3', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '37 hours', now() - interval '37 hours'
    from recipes where id = '986d4826-1115-59f6-b668-fa6ab24923e6'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'f8986d3d-2b75-532b-84b1-bf19eda9c736', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '986d4826-1115-59f6-b668-fa6ab24923e6' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'f8986d3d-2b75-532b-84b1-bf19eda9c736', position, body, minutes from recipe_steps where recipe_id = '986d4826-1115-59f6-b668-fa6ab24923e6' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('bd986fd6-a75a-582f-a89f-bfad026de8b9', '986d4826-1115-59f6-b668-fa6ab24923e6', 'f8986d3d-2b75-532b-84b1-bf19eda9c736', 'f81498e9-a866-50d7-a546-e0792b54c0c3', false, now() - interval '37 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '52a6e19b-ac75-5e46-8032-51fdb2279ef7', '6f8af8f2-632e-57d6-b01e-705195e4132f', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '8 hours', now() - interval '8 hours'
    from recipes where id = 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '52a6e19b-ac75-5e46-8032-51fdb2279ef7', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '52a6e19b-ac75-5e46-8032-51fdb2279ef7', position, body, minutes from recipe_steps where recipe_id = 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('08319988-ece0-5a4e-8c89-ca59110c6080', 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', '52a6e19b-ac75-5e46-8032-51fdb2279ef7', '6f8af8f2-632e-57d6-b01e-705195e4132f', false, now() - interval '8 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '388fdb9c-f9f9-5f0b-b699-3380984a8b7a', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '212 hours', now() - interval '212 hours'
    from recipes where id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '388fdb9c-f9f9-5f0b-b699-3380984a8b7a', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '388fdb9c-f9f9-5f0b-b699-3380984a8b7a', position, body, minutes from recipe_steps where recipe_id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('6c59afba-ffa9-57cb-b0bc-7d1917251744', '154cf5f9-8f7b-5751-b9c8-c50b695803d2', '388fdb9c-f9f9-5f0b-b699-3380984a8b7a', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '212 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'a1137272-a72c-51cf-a5db-62c869241878', '29f4dd0f-206d-5413-a55f-b91340e3e561', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '81 hours', now() - interval '81 hours'
    from recipes where id = '19b6fd5b-a771-522a-ace0-70a67067a544'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'a1137272-a72c-51cf-a5db-62c869241878', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '19b6fd5b-a771-522a-ace0-70a67067a544' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'a1137272-a72c-51cf-a5db-62c869241878', position, body, minutes from recipe_steps where recipe_id = '19b6fd5b-a771-522a-ace0-70a67067a544' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('ba86ad8c-c14c-55b2-a493-5bad969dcb99', '19b6fd5b-a771-522a-ace0-70a67067a544', 'a1137272-a72c-51cf-a5db-62c869241878', '29f4dd0f-206d-5413-a55f-b91340e3e561', false, now() - interval '81 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'e6acedbf-252b-5e2f-81bd-a757ddbc4ebc', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '16 hours', now() - interval '16 hours'
    from recipes where id = '986d4826-1115-59f6-b668-fa6ab24923e6'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'e6acedbf-252b-5e2f-81bd-a757ddbc4ebc', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '986d4826-1115-59f6-b668-fa6ab24923e6' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'e6acedbf-252b-5e2f-81bd-a757ddbc4ebc', position, body, minutes from recipe_steps where recipe_id = '986d4826-1115-59f6-b668-fa6ab24923e6' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('e84f9c5c-4849-544e-a626-3b011af8acfd', '986d4826-1115-59f6-b668-fa6ab24923e6', 'e6acedbf-252b-5e2f-81bd-a757ddbc4ebc', 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2', false, now() - interval '16 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '5f43e73a-fcd4-5bb0-854f-99f247cbbb6b', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '6 hours', now() - interval '6 hours'
    from recipes where id = 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '5f43e73a-fcd4-5bb0-854f-99f247cbbb6b', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '5f43e73a-fcd4-5bb0-854f-99f247cbbb6b', position, body, minutes from recipe_steps where recipe_id = 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('b99bd112-7512-533a-bee0-2de8016f06c4', 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a', '5f43e73a-fcd4-5bb0-854f-99f247cbbb6b', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '6 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select 'ffd8112c-8273-540b-9a9b-cd103fd62cca', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '26 hours', now() - interval '26 hours'
    from recipes where id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select 'ffd8112c-8273-540b-9a9b-cd103fd62cca', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select 'ffd8112c-8273-540b-9a9b-cd103fd62cca', position, body, minutes from recipe_steps where recipe_id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('19e14408-a1a1-5481-b7fd-13e3a9bda5c5', '154cf5f9-8f7b-5751-b9c8-c50b695803d2', 'ffd8112c-8273-540b-9a9b-cd103fd62cca', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '26 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '612f5e1f-f847-5f0f-af73-f49001ba30ac', '3dd979f4-93c0-5058-8eb7-8e06046c8682', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '61 hours', now() - interval '61 hours'
    from recipes where id = 'f4134598-19a8-5684-8ad4-3f26f1c91929'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '612f5e1f-f847-5f0f-af73-f49001ba30ac', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = 'f4134598-19a8-5684-8ad4-3f26f1c91929' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '612f5e1f-f847-5f0f-af73-f49001ba30ac', position, body, minutes from recipe_steps where recipe_id = 'f4134598-19a8-5684-8ad4-3f26f1c91929' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('3125ce4e-1b31-5544-bf3c-f095e240b13b', 'f4134598-19a8-5684-8ad4-3f26f1c91929', '612f5e1f-f847-5f0f-af73-f49001ba30ac', '3dd979f4-93c0-5058-8eb7-8e06046c8682', false, now() - interval '61 hours')
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select '2f160bb4-e82d-53a1-ab25-6fcf08e8970f', '6181e113-9005-5113-87e3-2c5e1ce00abb', title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, 'private', cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, now() - interval '56 hours', now() - interval '56 hours'
    from recipes where id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2'
  on conflict (id) do update set created_at = excluded.created_at;
insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select '2f160bb4-e82d-53a1-ab25-6fcf08e8970f', position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2' on conflict do nothing;
insert into recipe_steps (recipe_id, position, body, minutes) select '2f160bb4-e82d-53a1-ab25-6fcf08e8970f', position, body, minutes from recipe_steps where recipe_id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2' on conflict do nothing;
insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values ('e6df362c-fe87-5cde-9739-0c0b42647e5f', '154cf5f9-8f7b-5751-b9c8-c50b695803d2', '2f160bb4-e82d-53a1-ab25-6fcf08e8970f', '6181e113-9005-5113-87e3-2c5e1ce00abb', false, now() - interval '56 hours')
  on conflict (id) do update set created_at = excluded.created_at;
update recipes r set copies_count = (select count(*) from recipe_copies c where c.source_id = r.id);
insert into beta_testers (profile_id, joined_on, note) values ('69e35bef-6695-5b4f-89f7-684f67bd404c', current_date - 21, 'personne fictive') on conflict (profile_id) do nothing;
delete from app_events where profile_id = '69e35bef-6695-5b4f-89f7-684f67bd404c';
insert into app_events (profile_id, name, created_at) values
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '21 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '20 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '19 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '18 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '17 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '16 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '15 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '14 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '12 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '9 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '7 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '6 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '4 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '3 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '1 days'),
  ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'app_open', now() - interval '0 days');
insert into beta_testers (profile_id, joined_on, note) values ('ed018e6a-4007-5baf-bcf6-ab10a793deec', current_date - 21, 'personne fictive') on conflict (profile_id) do nothing;
delete from app_events where profile_id = 'ed018e6a-4007-5baf-bcf6-ab10a793deec';
insert into app_events (profile_id, name, created_at) values
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '21 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '18 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '17 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '16 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '15 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '14 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '13 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '12 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '11 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '10 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '8 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '7 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '6 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '5 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '2 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '1 days'),
  ('ed018e6a-4007-5baf-bcf6-ab10a793deec', 'app_open', now() - interval '0 days');
insert into beta_testers (profile_id, joined_on, note) values ('f81498e9-a866-50d7-a546-e0792b54c0c3', current_date - 21, 'personne fictive') on conflict (profile_id) do nothing;
delete from app_events where profile_id = 'f81498e9-a866-50d7-a546-e0792b54c0c3';
insert into app_events (profile_id, name, created_at) values
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '21 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '20 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '19 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '17 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '16 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '15 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '14 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '13 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '12 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '11 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '10 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '9 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '8 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '7 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '6 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '5 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '4 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '3 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '2 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '1 days'),
  ('f81498e9-a866-50d7-a546-e0792b54c0c3', 'app_open', now() - interval '0 days');
insert into beta_testers (profile_id, joined_on, note) values ('6f8af8f2-632e-57d6-b01e-705195e4132f', current_date - 21, 'personne fictive') on conflict (profile_id) do nothing;
delete from app_events where profile_id = '6f8af8f2-632e-57d6-b01e-705195e4132f';
insert into app_events (profile_id, name, created_at) values
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '21 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '19 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '18 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '17 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '16 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '15 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '14 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '13 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '11 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '10 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '7 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '4 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '2 days'),
  ('6f8af8f2-632e-57d6-b01e-705195e4132f', 'app_open', now() - interval '1 days');
insert into beta_testers (profile_id, joined_on, note) values ('29f4dd0f-206d-5413-a55f-b91340e3e561', current_date - 21, 'personne fictive') on conflict (profile_id) do nothing;
delete from app_events where profile_id = '29f4dd0f-206d-5413-a55f-b91340e3e561';
insert into app_events (profile_id, name, created_at) values
  ('29f4dd0f-206d-5413-a55f-b91340e3e561', 'app_open', now() - interval '21 days');
insert into beta_testers (profile_id, joined_on, note) values ('c6512930-0382-50bb-b18a-db918ff78f26', current_date - 21, 'personne fictive') on conflict (profile_id) do nothing;
delete from app_events where profile_id = 'c6512930-0382-50bb-b18a-db918ff78f26';
insert into app_events (profile_id, name, created_at) values
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '21 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '20 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '19 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '18 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '16 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '15 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '14 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '10 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '6 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '5 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '3 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '2 days'),
  ('c6512930-0382-50bb-b18a-db918ff78f26', 'app_open', now() - interval '0 days');
insert into beta_testers (profile_id, joined_on, note) values ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', current_date - 21, 'personne fictive') on conflict (profile_id) do nothing;
delete from app_events where profile_id = 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2';
insert into app_events (profile_id, name, created_at) values
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '21 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '20 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '19 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '18 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '17 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '16 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '15 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '13 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '12 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '11 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '10 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '9 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '5 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '3 days'),
  ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', 'app_open', now() - interval '2 days');
insert into beta_testers (profile_id, joined_on, note) values ('3dd979f4-93c0-5058-8eb7-8e06046c8682', current_date - 21, 'personne fictive') on conflict (profile_id) do nothing;
delete from app_events where profile_id = '3dd979f4-93c0-5058-8eb7-8e06046c8682';
insert into app_events (profile_id, name, created_at) values
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '21 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '20 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '19 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '18 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '16 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '14 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '13 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '9 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '7 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '6 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '5 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '4 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '3 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '2 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '1 days'),
  ('3dd979f4-93c0-5058-8eb7-8e06046c8682', 'app_open', now() - interval '0 days');
insert into beta_testers (profile_id, joined_on, note) values ('6181e113-9005-5113-87e3-2c5e1ce00abb', current_date - 21, 'personne fictive') on conflict (profile_id) do nothing;
delete from app_events where profile_id = '6181e113-9005-5113-87e3-2c5e1ce00abb';
insert into app_events (profile_id, name, created_at) values
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '21 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '20 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '18 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '17 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '16 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '14 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '13 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '11 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '10 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '9 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '8 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '7 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '5 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '3 days'),
  ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'app_open', now() - interval '1 days');
insert into beta_testers (profile_id, joined_on, note) values ('67c5aecd-680b-5574-aa4c-082784fe7707', current_date - 21, 'personne fictive') on conflict (profile_id) do nothing;
delete from app_events where profile_id = '67c5aecd-680b-5574-aa4c-082784fe7707';
insert into app_events (profile_id, name, created_at) values
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '21 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '20 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '19 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '16 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '14 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '10 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '8 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '7 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '6 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '5 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '4 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '2 days'),
  ('67c5aecd-680b-5574-aa4c-082784fe7707', 'app_open', now() - interval '0 days');
insert into beta_testers (profile_id, joined_on, note) values ('ed48de41-79b0-595b-a0cd-984366f827e6', current_date - 21, 'personne fictive') on conflict (profile_id) do nothing;
delete from app_events where profile_id = 'ed48de41-79b0-595b-a0cd-984366f827e6';
insert into app_events (profile_id, name, created_at) values
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '21 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '20 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '19 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '18 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '17 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '16 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '15 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '14 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '13 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '12 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '11 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '10 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '9 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '8 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '7 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '6 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '5 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '4 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '3 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '2 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '1 days'),
  ('ed48de41-79b0-595b-a0cd-984366f827e6', 'app_open', now() - interval '0 days');
insert into price_survey (profile_id, price_cents, answer, wants) values ('69e35bef-6695-5b4f-89f7-684f67bd404c', survey_price('69e35bef-6695-5b4f-89f7-684f67bd404c'), 'no', '')
  on conflict (profile_id) do nothing;
insert into price_survey (profile_id, price_cents, answer, wants) values ('ed018e6a-4007-5baf-bcf6-ab10a793deec', survey_price('ed018e6a-4007-5baf-bcf6-ab10a793deec'), 'maybe', '')
  on conflict (profile_id) do nothing;
insert into price_survey (profile_id, price_cents, answer, wants) values ('f81498e9-a866-50d7-a546-e0792b54c0c3', survey_price('f81498e9-a866-50d7-a546-e0792b54c0c3'), 'no', '')
  on conflict (profile_id) do nothing;
insert into price_survey (profile_id, price_cents, answer, wants) values ('6f8af8f2-632e-57d6-b01e-705195e4132f', survey_price('6f8af8f2-632e-57d6-b01e-705195e4132f'), 'no', '')
  on conflict (profile_id) do nothing;
insert into price_survey (profile_id, price_cents, answer, wants) values ('29f4dd0f-206d-5413-a55f-b91340e3e561', survey_price('29f4dd0f-206d-5413-a55f-b91340e3e561'), 'no', '')
  on conflict (profile_id) do nothing;
insert into price_survey (profile_id, price_cents, answer, wants) values ('c6512930-0382-50bb-b18a-db918ff78f26', survey_price('c6512930-0382-50bb-b18a-db918ff78f26'), 'no', '')
  on conflict (profile_id) do nothing;
insert into price_survey (profile_id, price_cents, answer, wants) values ('d60940aa-e2b9-5be9-b000-dcbf4cf769e2', survey_price('d60940aa-e2b9-5be9-b000-dcbf4cf769e2'), 'maybe', '')
  on conflict (profile_id) do nothing;
insert into price_survey (profile_id, price_cents, answer, wants) values ('3dd979f4-93c0-5058-8eb7-8e06046c8682', survey_price('3dd979f4-93c0-5058-8eb7-8e06046c8682'), 'yes', '')
  on conflict (profile_id) do nothing;
update profiles set trial_until = now() + interval '9 days' where id = '69e35bef-6695-5b4f-89f7-684f67bd404c';
update profiles set trial_until = now() + interval '9 days' where id = 'ed018e6a-4007-5baf-bcf6-ab10a793deec';
update profiles set trial_until = now() + interval '9 days' where id = 'f81498e9-a866-50d7-a546-e0792b54c0c3';
update profiles set trial_until = now() + interval '9 days' where id = '6f8af8f2-632e-57d6-b01e-705195e4132f';
update profiles set trial_until = now() + interval '9 days' where id = '29f4dd0f-206d-5413-a55f-b91340e3e561';
update profiles set trial_until = now() + interval '9 days' where id = 'c6512930-0382-50bb-b18a-db918ff78f26';
update profiles set trial_until = now() + interval '9 days' where id = 'd60940aa-e2b9-5be9-b000-dcbf4cf769e2';
update profiles set trial_until = now() + interval '9 days' where id = '3dd979f4-93c0-5058-8eb7-8e06046c8682';
update profiles set trial_until = now() + interval '9 days' where id = '6181e113-9005-5113-87e3-2c5e1ce00abb';
update profiles set trial_until = now() + interval '9 days' where id = '67c5aecd-680b-5574-aa4c-082784fe7707';
update profiles set trial_until = now() + interval '9 days' where id = 'ed48de41-79b0-595b-a0cd-984366f827e6';
insert into preorders (profile_id, stripe_session_id, amount_cents, paid_at) values ('ed48de41-79b0-595b-a0cd-984366f827e6', 'cs_test_fictif_1', 2900, now() - interval '1 days') on conflict (stripe_session_id) do nothing;
insert into preorders (profile_id, stripe_session_id, amount_cents, paid_at) values ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'cs_test_fictif_2', 2900, now() - interval '2 days') on conflict (stripe_session_id) do nothing;
insert into preorders (profile_id, stripe_session_id, amount_cents, paid_at) values ('67c5aecd-680b-5574-aa4c-082784fe7707', 'cs_test_fictif_3', 2900, now() - interval '3 days') on conflict (stripe_session_id) do nothing;
insert into app_events (profile_id, name, created_at) values ('ed48de41-79b0-595b-a0cd-984366f827e6', 'family_export', now() - interval '5 days');
insert into app_events (profile_id, name, created_at) values ('67c5aecd-680b-5574-aa4c-082784fe7707', 'family_export', now() - interval '5 days');
update recipes set challenge_id = (select id from current_challenge()), challenge_week = current_week_start() where id = '3f0de9c8-e489-54ae-9da1-b4c419f90451';
update recipes set challenge_id = (select id from current_challenge()), challenge_week = current_week_start() where id = '11014cbe-2751-5e01-9aac-a5db633adefc';
update recipes set challenge_id = (select id from current_challenge()), challenge_week = current_week_start() where id = 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a';
update profiles set premium_until = now() + interval '90 days' where id = 'ed48de41-79b0-595b-a0cd-984366f827e6';
insert into family_books (id, name, owner_id, invite_code) values ('4ed2b6ca-009c-5aa3-87e7-4323f4cd3867', 'Famille Laurent', 'ed48de41-79b0-595b-a0cd-984366f827e6', 'LAURENT1') on conflict (id) do nothing;
insert into family_members (book_id, profile_id, role) values ('4ed2b6ca-009c-5aa3-87e7-4323f4cd3867', 'ed48de41-79b0-595b-a0cd-984366f827e6', 'owner'), ('4ed2b6ca-009c-5aa3-87e7-4323f4cd3867', '67c5aecd-680b-5574-aa4c-082784fe7707', 'member') on conflict do nothing;
insert into family_recipes (book_id, recipe_id, added_by, note) values ('4ed2b6ca-009c-5aa3-87e7-4323f4cd3867', '7fe979fb-9be5-5747-b26e-88fb796989cd', 'ed48de41-79b0-595b-a0cd-984366f827e6', 'Celui de mamie Jeanne, à Noël.') on conflict do nothing;
insert into family_recipes (book_id, recipe_id, added_by, note) values ('4ed2b6ca-009c-5aa3-87e7-4323f4cd3867', 'd311b89b-5143-56e3-9090-f3d65f707025', 'ed48de41-79b0-595b-a0cd-984366f827e6', '') on conflict do nothing;
insert into family_recipes (book_id, recipe_id, added_by, note) values ('4ed2b6ca-009c-5aa3-87e7-4323f4cd3867', '0cdd1fe9-6e85-52be-b135-ec0521845838', '67c5aecd-680b-5574-aa4c-082784fe7707', 'Ma version aux poires.') on conflict do nothing;
commit;
