# Local Bike Analytics

Projet final de la formation Analytics Engineer - modéliser les données de **Local Bike**, une enseigne de vente de vélos, pour construire son premier tableau de bord.

> **Les données sont simulées.** Elles ont été générées.Elles ne proviennent d'aucune entreprise réelle.

## Stack

| Rôle | Outil |
|---|---|
| Entrepôt de données | Google BigQuery (projet `databird-513513`, région `US`) |
| Transformation | dbt Cloud |
| Versionnement | GitHub |
| Tableau de bord | Looker Studio (bonus) |

## Questions business

1. Chiffre d'affaires par mois et par magasin
2. Top 10 des produits les plus vendus (quantité et montant)
3. Panier moyen par commande
4. Clients qui achètent le plus
5. Stock disponible par magasin

Chaque question a sa requête dans `analyses/` (`q1` à `q5`), construite uniquement sur les marts.

## Architecture (ELT)

```
BigQuery local_bike_raw      données brutes (6 tables, colonnes en français)
        │  source()
        ▼
models/staging   (vues)      stg_local_bike__*  : renommage en anglais, typage
        │  ref()
        ▼
models/marts     (tables)    schéma en étoile   : faits + dimensions
        │
        ▼
analyses/ + tableau de bord
```

### Sources (`local_bike_raw`)

| Table | Lignes |
|---|---|
| `stores` | 5 |
| `products` | 21 |
| `customers` | 300 |
| `orders` | 3 000 |
| `order_items` | 7 540 |
| `stocks` | 105 |

### Marts

| Modèle | Grain | Contenu |
|---|---|---|
| `fct_sales` | une ligne de commande | quantité, prix, remise, `gross_amount`, `net_amount` |
| `fct_stocks` | un produit dans un magasin | `quantity_available` |
| `dim_stores` | un magasin | nom, ville |
| `dim_products` | un produit | nom, catégorie, prix catalogue |
| `dim_customers` | un client | nom, ville |

`fct_sales` est partitionnée par `order_date` et clusterisée par `store_id`. Sur ce volume, le gain est négligeable : la configuration est en place pour une montée en charge.

## Tests

| Type | Exemple | Pourquoi |
|---|---|---|
| `unique` + `not_null` | `fct_sales.sale_id` | une clé doit identifier une seule ligne |
| `relationships` | `fct_sales.store_id` → `dim_stores` | aucune vente vers un magasin inexistant |
| `accepted_values` | `discount` ∈ {0, 0.05, 0.1} ; `category` | détecter une valeur inattendue |
| Tests métier | `assert_sales_amount_not_negative`, `assert_stock_not_negative` | un montant ou un stock ne peut pas être négatif |

## Lancer le projet

```bash
dbt build                      # construit les modèles et lance les tests
dbt run --select staging       # staging seul
dbt test                       # tests seuls
dbt docs generate              # documentation et lineage
```

## Recréer les données brutes

Les 6 CSV simulés sont versionnés dans `seeds/`. Ils sont **désactivés par défaut** : `dbt build` ne les charge pas et n'écrase jamais `local_bike_raw`.

Pour recréer les tables brutes dans le dataset `local_bike_raw` :

```bash
dbt seed --vars '{load_raw_seeds: true}'
```

La macro `macros/generate_schema_name.sql` envoie les seeds dans `local_bike_raw` tel quel ; les modèles restent dans le dataset de la cible (`local_bike_dev`, `local_bike_ci`).

