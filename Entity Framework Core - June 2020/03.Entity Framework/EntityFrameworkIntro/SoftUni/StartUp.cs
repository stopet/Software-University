using SoftUni.Data;
using SoftUni.Models;
using System;
using System.Globalization;
using System.Linq;
using System.Text;

namespace SoftUni
{
    public class StartUp
    {
        static void Main(string[] args)
        {
            SoftUniContext context = new SoftUniContext();

            string result = GetEmployee147(context);

            Console.WriteLine(result);
        }

        //Problem 03
        public static string GetEmployeesFullInformation(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employees = context
                .Employees
                .OrderBy(e=>e.EmployeeId)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    e.MiddleName,
                    e.JobTitle,
                    e.Salary
                })
                .ToList();

            foreach (var e in employees)
            {
                sb
                    .AppendLine($"{e.FirstName} {e.LastName} {e.MiddleName} " +
                    $"{e.JobTitle} {e.Salary:f2}");
                  
            }

            return sb.ToString().TrimEnd();
        }
        //Problem 04
        public static string GetEmployeesWithSalaryOver50000(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employees = context
                .Employees
                .Where(e => e.Salary > 50000)
                .Select(e => new
                { 
                    e.FirstName,
                    e.Salary
                })
                .OrderBy(e => e.FirstName)
                .ToList();

            foreach (var e in employees)
            {
                sb
                    .AppendLine($"{ e.FirstName} - {e.Salary:f2}");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 05
        public static string GetEmployeesFromResearchAndDevelopment(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employees = context
                .Employees
                .Where(e => e.Department.Name == "Research and Development")
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    DepartmentName=e.Department.Name,
                    e.Salary
                })
                .OrderBy(e => e.Salary)
                .ThenByDescending(e => e.FirstName)
                .ToList();

            foreach (var e in employees)
            {
                sb
                    .AppendLine($"{e.FirstName} {e.LastName} from {e.DepartmentName} - ${e.Salary:f2}");
            }

            return sb.ToString().TrimEnd();

        }

        //Problem 06
        public static string AddNewAddressToEmployee(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            Address newAdress = new Address()
            {
                AddressText = "Vitoshka 15",
                TownId = 4

            };

            Employee employeeNakov = context
                .Employees
                .First(e => e.LastName == "Nakov");

            employeeNakov.Address = newAdress;

            context.SaveChanges();

            var addresses = context
                .Employees
                .OrderByDescending(e => e.AddressId)
                .Take(10)
                .Select(e => e.Address.AddressText)
                .ToList();

            foreach (var address in addresses)
            {
                sb.AppendLine(address);
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 07
        public static string GetEmployeesInPeriod(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employees = context
                .Employees
                .Where(e => e.EmployeesProjects.Any(ep =>
                  ep.Project.StartDate.Year >= 2001 &&
                  ep.Project.StartDate.Year <= 2003))
                .Take(10)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    ManagerFirstName = e.Manager.FirstName,
                    ManagerLastName = e.Manager.LastName,
                    Projects = e.EmployeesProjects
                        .Select(ep => new
                        {
                            ProjectName = ep.Project.Name,
                            StartDate = ep.Project.StartDate
                           .ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture),
                            EndDate = ep.Project.EndDate.HasValue ?
                           ep.Project.EndDate.Value.ToString("M/d/yyyy h:mm:ss tt", CultureInfo
                           .InvariantCulture) : "not finished"
                        })
                        .ToList()
                })
                .ToList();

            foreach (var e in employees)
            {
                sb.AppendLine($"{e.FirstName} {e.LastName} – Manager: {e.ManagerFirstName} {e.ManagerLastName}");

                foreach (var p in e.Projects)
                {
                    sb
                        .AppendLine($"--{p.ProjectName} - {p.StartDate} - {p.EndDate}");
                }
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 08
        public static string GetAddressesByTown(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();
            var addresses = context
                .Addresses
                .Select(a => new
                {
                    a.AddressText,
                    TownName = a.Town.Name,
                    EmployeeCount = a.Employees.Count()
                })
                .OrderByDescending(a => a.EmployeeCount)
                .ThenBy(a => a.TownName)
                .ThenBy(a => a.AddressText)
                .ToList();

            foreach (var a in addresses)
            {
                sb.AppendLine($"{a.AddressText}, {a.TownName} - {a.EmployeeCount} employees");
            }

            return sb.ToString().TrimEnd();
        }

        //Problem 09
        public static string GetEmployee147(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employee147 = context
                .Employees
                .Where(e => e.EmployeeId == 147)
                .Select(e => new
                {
                    e.FirstName,
                    e.LastName,
                    e.JobTitle,
                    Projects = e.EmployeesProjects
                    .Select(ep => ep.Project.Name)
                    .OrderBy(ep=>ep)
                    .ToList()
                })
                .Single();

            sb
                .AppendLine($"{employee147.FirstName} {employee147.LastName} - {employee147.JobTitle}");

            foreach (var projectName in employee147.Projects)
            {
                sb
                    .AppendLine(projectName);
            }

            return sb.ToString().TrimEnd();
        }
    }
}
