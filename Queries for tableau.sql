

/*

Queries used for Tableau Project

*/



-- 1.



select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from portfolio_project..covid_deaths$
where continent is not null
order by 1,2




-- 2.





select location, sum(cast(new_deaths as int )) as TotalDeathCount
from portfolio_project..covid_deaths$
where continent is null 
and location not in ('World', 'European Union', 'International')
group by location
order by TotalDeathCount desc



-- 3.



Select location, population, Max(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from portfolio_project..covid_deaths$
group by location, population
order by PercentPopulationInfected desc



-- 4. 



Select location, population, date, Max(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from portfolio_project..covid_deaths$
group by location, population,date
order by PercentPopulationInfected desc

-- 5.



Select dea.location, dea.population, Max(people_fully_vaccinated) as people_fully_vaccinatedCount,max((people_fully_vaccinated/population))*100 as PercentageOfPeopleVaccinated
from portfolio_project..covid_vacc$ vac
join portfolio_project..covid_deaths$ dea
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
group by dea.location, dea.population
order by PercentageOfPeopleVaccinated desc



