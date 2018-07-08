CREATE VIEW development_alpha.beta_users (id, name, email, created_at, updated_at)
  AS SELECT bu.id,bu.name,be.adress,bu.created_at,bu.updated_at
  FROM development_beta.users AS bu LEFT JOIN development_beta.emails AS be
    ON bu.id = be.user_id
