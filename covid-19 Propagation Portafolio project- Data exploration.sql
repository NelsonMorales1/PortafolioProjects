
SELECT *
FROM portafolioproject1..CovidDeaths$
Where continent is not null
ORDER by 3,4

--SELECT *
--FROM portafolioproject1..CovidVaccinations$
--ORDER by 3,4

--select data that we are going to be using

select location, date ,total_cases, new_cases, total_deaths, population
From portafolioproject1..CovidDeaths$
order by 1,2


-- Looking at total cases vs total deaths
-- shows the likelihood of dying if you contract covid in your country 

select location, date ,total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
From portafolioproject1..CovidDeaths$
where location like '%states%'
order by 1,2

-- Looking at the total cases vs the population
-- shows what percentege of population got covid

select location, date , total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From portafolioproject1..CovidDeaths$
--where location like '%states%'
order by 1,2


-- looking at countries with highes infection rate compared to population

select location, max(total_cases) as HighestInfectionCount, population, (max(total_cases/population))*100 as PercentPopulationInfected
From portafolioproject1..CovidDeaths$
--where location like '%states%'
Group by Location, population
order by PercentPopulationInfected desc


-- Showing the countries with the highest  death count per continent

Select location, max(cast(total_deaths as int)) as TotalDeathCount
From portafolioproject1..CovidDeaths$
--where location like '%states%'
Where continent is null
Group by Location
order by TotalDeathCount desc


--showing the continents with the highes death count population

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From portafolioproject1..CovidDeaths$
--where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc




-- Global Numbers

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death, sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
From portafolioproject1..CovidDeaths$
--where location like '%states%'
Where continent is not null
--Group by date
order by 1,2 


-- Looking at Total Population vs Vaccination
-- shows the percentage of population that has received at least one covid vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, 
dea.date) as RollingPeopleVaccinated
From portafolioproject1..CovidDeaths$ dea
Join portafolioproject1..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


-- using CTE to perform calculation on partition by previous query

With PopvsVac ( Continent, Location, Date, Population,New_vaccinations, RollingPeopleVaccinated)
As
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, 
dea.date) as RollingPeopleVaccinated
From portafolioproject1..CovidDeaths$ dea
Join portafolioproject1..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Using TEMP table to perform calculation on partition by previous query

Drop Table if exists #PercenPopulationVaccinated
Create Table #PercenPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinated numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercenPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, 
dea.date) as RollingPeopleVaccinated
From portafolioproject1..CovidDeaths$ dea
Join portafolioproject1..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select*, (RollingPeopleVaccinated/Population)*100
From #PercenPopulationVaccinated


-- Creating view to store data for later visualization

Create  view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, 
dea.date) as RollingPeopleVaccinated
From portafolioproject1..CovidDeaths$ dea
Join portafolioproject1..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3