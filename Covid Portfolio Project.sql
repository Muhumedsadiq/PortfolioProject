select *
From PortfolioProject..[CovidDeaths ]
Where continent is not null
order by 3, 4

--Select Dta that we re going to be using 

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..[CovidDeaths ]
Order by 1,2

-- Looking at Total Cases vs Total Deaths 
-- shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..[CovidDeaths ]
Where location like '%states%'
order by 1,2




--Looking at total cases vs population
--Shows what percent got infected 


Select location, date, total_cases, Population, (total_cases/Population)*100 as Percentinfected
From portfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2 

--Looking at Countriex with Highest Infection rate compared to Population


Select location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as PercentPopulationInfected
From PortfolioProject..[CovidDeaths ]
Group by location, Population
Order by PercentPopulationInfected desc


--Looking at contries with Highest number of Death

Select location, Population, Max(cast(total_deaths as int)) as HighestDeathCount, Max((total_Deaths/Population))*100 as PercentPopulationDeath
From PortfolioProject..[CovidDeaths ]
Where continent is not null
Group by location, population
Order by PercentPopulationDeath desc

-- LET's Break Things down by continent 

Select location,continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..[CovidDeaths ]
Where Continent is not null 
Group by location,continent
Order by TotalDeathCount desc


--showing continent with highest count per population

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..[CovidDeaths ]
Where Continent is not null 
Group by continent
Order by TotalDeathCount desc



--Global Numbers 


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(Cast(new_deaths as int))/Sum(new_cases) *100 as DeathPercentage 
--Where location like '%states%'
FROM PortfolioProject..[CovidDeaths ]
Where continent is not null
--Group by date
order by 1,2

-- Looking at Total Population vs Vaccinations


Select *  
From PortfolioProject..[CovidDeaths ] dea
join PortfolioProject..['CovidVaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 1,2,3

Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations
, sum(cast(dea.new_vaccinations as int)) over (partition by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..[CovidDeaths ] dea
Join PortfolioProject..['CovidVaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3



-- Looking at Total Population vs Vaccinations
--USE CTE 


With PopvsVAc (Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations
, sum(cast(dea.new_vaccinations as int)) over (partition by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..[CovidDeaths ] dea
Join PortfolioProject..['CovidVaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEmp table 

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric, 
RollingPeopleVaccination numeric
)


Insert into #PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations
, sum(cast(dea.new_vaccinations as int)) over (partition by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..[CovidDeaths ] dea
Join PortfolioProject..['CovidVaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccination/Population)*100
From #PercentPopulationVaccinated



--Create a view to store data for later visualizations (MAKE SURE YOU CREATE MORE)

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations
, sum(cast(dea.new_vaccinations as int)) over (partition by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..[CovidDeaths ] dea
Join PortfolioProject..['CovidVaccinations] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3



Select *
From #PercentPopulationVaccinated










--select *
--From PortfolioProject..['CovidVaccinations]
--order by 3, 4