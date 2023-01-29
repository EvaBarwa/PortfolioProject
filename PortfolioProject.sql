

select * 
from portfolio_project..covid_deaths$


select location, date, total_cases, new_cases, total_deaths, population
from portfolio_project..covid_deaths$
order by 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolio_project..covid_deaths$
where location = 'India'
order by 1,2

select location, date,population,total_cases, (total_cases/population)*100 as total_casesPercentage
from portfolio_project..covid_deaths$
order by 1,2

--looking for countries with highest infection rate 
select location, population,max(total_cases) as highest_infection_rate, max(total_cases/population)*100 as PercentagePopulationInfected
from portfolio_project..covid_deaths$
group by location, population
order by PercentagePopulationInfected desc

--countries with the highest death rate

select location, max(cast(total_deaths as int)) as total_death_count
from portfolio_project..covid_deaths$
where continent is not null
group by location
order by total_death_count desc

select location, max(cast(total_deaths as int)) as total_death_count
from portfolio_project..covid_deaths$
where continent is null
group by location
order by total_death_count desc


--showing the continent with highest death count

select continent, max(cast(total_deaths as int)) as total_death_count
from portfolio_project..covid_deaths$
where continent is not null
group by continent
order by total_death_count desc

--global numbers

select date, sum(new_cases) as total_cases, sum(cast (new_deaths as int)) as total_deaths, (sum(cast (new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from portfolio_project..covid_deaths$
--where location = 'India'
where continent is not null
group by date
order by 1,2

-- total cases

select sum(new_cases) as total_cases, sum(cast (new_deaths as int)) as total_deaths, (sum(cast (new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from portfolio_project..covid_deaths$
--where location = 'India'
where continent is not null
--group by date
order by 1,2

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolio_project..covid_deaths$ dea
join portfolio_project..covid_vacc$ vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 2,3

-- use CTE


with PopvsVac (continent, location, date, population, new_vaccinations , RollingPeopleVaccinated)
as 
(
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolio_project..covid_deaths$ dea
join portfolio_project..covid_vacc$ vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  )
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

--temp table 
drop table if exists #PrecentagePopulationVaccinated
create table #PrecentagePopulationVaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime, 
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
)
insert into #PrecentagePopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolio_project..covid_deaths$ dea
join portfolio_project..covid_vacc$ vac
  on dea.location = vac.location
  and dea.date = vac.date
 --where dea.continent is not null

select *, (RollingPeopleVaccinated/population)*100
from #PrecentagePopulationVaccinated



--creating view to store data for visualisation

create view PrecentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolio_project..covid_deaths$ dea
join portfolio_project..covid_vacc$ vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null

select *
from PrecentPopulationVaccinated