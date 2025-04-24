# Introduction

Projet visant à avoir un aperçu complet puis sélectif du marché du travail de la Data Analyse issu de données de 2023. Il s'agit aussi de démontrer une utilisation de requêtes basiques en SQL.

Le but final est de pouvoir ressortir des données objectives permettant de mieux cibler les skills et outils les plus valorisés sur le marché.

Vous pouvez trouver les requêtes ici [project_sql folder](/project_sql/)

# Background

## Détails

Le projet est un suivi du projet de Luke Barousse visant à apprendre à requêter efficacement.

Plus de détails [sur ce lien](https://youtu.be/7mz73uXD9DA).

## Questions auxquelles répondent les requêtes

Les requêtes répondaient aux questions suivantes :

1. Quel est le salaire des postes de Data Analyst qui payent le mieux ?

2. Quelles sont les compétences nécessaires pour ces postes ?

3. Quelles compétences sont les plus demandées pour les Data Analyst ?

4. Quelles compétences semblent être corrélées avec un haut salaire ?

5. Finalement, quelles sont les compétences les plus optimales à acquérir ?

# Outils

Le projet a nécessité la maîtrise de plusieurs outils :

- **SQL** : c'est la pièce maitresse du projet et la compétence que je souhaitais démontrer via cet exercice ;
- **PostgreSQL** : j'ai choisi cette database car elle est la plus demandée par les employeurs selon les données de 2023 ;
- **Visual Studio Code** : mon éditeur de code par défaut ;
- **Git & GitHub** : la plateforme de partage et projet la plus pertinente et la plus utilisée à ce jour.

# Analyse

Les 4 premières requêtes ont permis de construire la requête qui pourrait être une demande faite dans un projet professionnel.

J'ai ainsi pu apprendre à utiliser des CTEs et des Subqueries de manière efficace et construite.

Voici les compétences les plus demandées sur le marché français :

| Compétence | Nombre de demandes |
| ---------- | ------------------ |
| SQL        | 1950               |
| Python     | 1541               |
| Tableau    | 1048               |
| Power BI   | 791                |
| Excel      | 751                |

Voici la visualisation finale des données et comment se structure la requête des données les plus rentables :

![Compétences_les_plus_rentables](Assets\Compétences_les_plus_rentables.png)

```sql
WITH skills_demand AS (
    SELECT skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND (
            job_location = 'Paris, France'
            OR job_work_from_home = TRUE
        )
    GROUP BY skills_dim.skill_id
),
average_salary AS (
    SELECT skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS salaire_moyen
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND (
            job_location = 'Paris, France'
            OR job_work_from_home = TRUE
        )
    GROUP BY skills_dim.skill_id
)
SELECT skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    salaire_moyen
FROM skills_demand
    INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY average_salary DESC,
    demand_count DESC
LIMIT 20
```

# Conclusion

Ce projet permet de mettre en valeur des requêtes SQL complexes et a aussi permis de comprendre plus en profondeur le marché du travail pour le poste de Data Analyst en France.

Il semblerait que des compétences comme SQL et Python soient de très bonnes portes d'entrée au métier, mais finalement ce sont les compétences soit les plus basiques soit les plus niches qui sont demandées dans les top jobs de ce secteur.
