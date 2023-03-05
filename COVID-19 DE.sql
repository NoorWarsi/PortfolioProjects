--Select data we are going to be using 

select location, date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by 1,2

--Looking at total cases Vs total deaths
-- show likelihoof of dying if you contract Covid in your country
select location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from CovidDeaths
where location like '%canada%'
order by 1,2

--looking at total cases vs population
-- shows whatpercentage of population has got COVID

select location, date,total_cases,Population, (total_cases/Population)*100 as PopulationPercentageInfected
from CovidDeaths
where location like '%canada%'
order by 1,2

--looking at countries with highest infection rate as compare to population
select location,MAX(total_cases) As highestinfectedpeople ,Population, max((total_cases/Population))*100 as PopulationPercentageInfected
from CovidDeaths
--where location like '%canada%'
Group by location, Population
order by PopulationPercentageInfected desc;

--Showing countries with highest death count per population
select location,MAX(cast(total_deaths as int)) As highestDeaths 
from CovidDeaths
--where location like '%canada%'
where continent is not null
Group by location
order by highestDeaths desc;	

--Showing countries with highest death count per continent
select continent,MAX(cast(total_deaths as int)) As highestDeaths 
from CovidDeaths
--where location like '%canada%'
where continent is not null
Group by continent
order by highestDeaths desc;


 --looking at total population vs vaccination
 -- joining two tables death and vaccination

 select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
 from CovidDeaths dea
 join CovidVacci vacc
 on dea.location = vacc.location
 and dea.date = vacc.date
 where dea.continent is not null
 order by 2,3

 ---looking at total population vs new vaccination (rolling count approach)

 select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, 
 SUM(vacc.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollinPeopleVacc 
 from CovidDeaths dea
 join CovidVacci vacc
 on dea.location = vacc.location
 and dea.date = vacc.date
 where dea.continent is not null
 order by 2,3

 --Creating view for further visualization

 create view RollinPeopleVacc as
 select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, 
 SUM(vacc.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollinPeopleVacc 
 from CovidDeaths dea
 join CovidVacci vacc
 on dea.location = vacc.location
 and dea.date = vacc.date
 where dea.continent is not null
 --order by 2,3





