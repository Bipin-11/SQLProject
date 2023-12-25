select * 
from CovidDeaths$
where continent is not null
order by 3,4

select * 
from CovidVaccinations$
order by 3,4

--select data that we are going to be using
select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths$
order by 1,2

--Total cases vs Total Deaths
--show likelihood of dying if you contract covid in your country
select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where location like 'Nep%'
order by 1,2

--Total cases vs Population
--show what percentage of population infected with Covid
select location,date,total_cases,population,(total_cases/population)*100 as PopulationPercentageInfected
from CovidDeaths$
where location like 'Nep%'
order by 1,2

--Countries with Highest Infection Rate compared to Population
select location, population, max(total_cases) as HighestInfectionCount,
max((total_cases/population))*100 as PopulationPercentageInfected
from CovidDeaths$
Group by location, population
Order by PopulationPercentageInfected desc

 
--Contintents with the highest Death count per population
select continent, max(cast(total_deaths as int)) as HighestDeathCount
from CovidDeaths$
where continent is not null
Group By continent
Order by HighestDeathCount desc


--Global Number
select date,sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths$
where continent is not null
Group by date
Order by 4 desc


--Total populations vs vaccations
--Show percentage of population that has received at least one Covid Vaccine
select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
sum(cast(vaccination.new_vaccinations as int)) Over (Partition by death.location order by 
death.location, death.date) as RollingPeopleVaccinated
from CovidDeaths$ death
join CovidVaccinations$ vaccination
on death.location= vaccination.location
and death.date= vaccination.date
where death.continent is not null
order by 2,3

--Using CTE to perform Calculation on Partition By in previous query
with PopvsVac (Contitnent,Location, Date,Population, New_vaccinations,RollingPeopleVaccinated)
as (
select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
sum(cast(vaccination.new_vaccinations as int)) Over (Partition by death.location order by 
death.location, death.date) as RollingPeopleVaccinated
from CovidDeaths$ death
join CovidVaccinations$ vaccination
on death.location= vaccination.location
and death.date= vaccination.date
where death.continent is not null
)
select *, (RollingPeopleVaccinated/population) *100
from PopvsVac


--Using Temp table to perform calculation on Partition By in previous query
Create Table #PeoplePopulationVaccinated
(
Continent nvarchar(50),
Location nvarchar(50),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PeoplePopulationVaccinated
select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
sum(cast(vaccination.new_vaccinations as int)) Over (Partition by death.location order by 
death.location, death.date) as RollingPeopleVaccinated
from CovidDeaths$ death
join CovidVaccinations$ vaccination
on death.location= vaccination.location
and death.date= vaccination.date
where death.continent is not null

select *, (RollingPeopleVaccinated/Population) *100
from #PeoplePopulationVaccinated


--Creating view
create view PeoplePopulationVaccinated as
select death.continent, death.location, death.date, death.population, vaccination.new_vaccinations,
sum(cast(vaccination.new_vaccinations as int)) Over (Partition by death.location order by 
death.location, death.date) as RollingPeopleVaccinated
from CovidDeaths$ death
join CovidVaccinations$ vaccination
on death.location= vaccination.location
and death.date= vaccination.date
where death.continent is not null


select * 
from PeoplePopulationVaccinated