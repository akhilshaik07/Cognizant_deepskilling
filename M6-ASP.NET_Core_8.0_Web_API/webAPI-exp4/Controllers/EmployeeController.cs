using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WebApiExp3.Models;

namespace WebApiExp3.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Admin,POC")]
    public class EmployeeController : ControllerBase
    {
        private List<Employee> _employees;

        public EmployeeController()
        {
            _employees = GetStandardEmployeeList();
        }

        private List<Employee> GetStandardEmployeeList()
        {
            return new List<Employee>
            {
                new Employee
                {
                    Id = 1,
                    Name = "Akhil",
                    Salary = 60000,
                    Permanent = true,
                    Department = new Department { Id = 1, Name = "Engineering" },
                    Skills = new List<Skill>
                    {
                        new Skill { Id = 1, Name = "C#" },
                        new Skill { Id = 2, Name = "SQL" }
                    },
                    DateOfBirth = new DateTime(2004, 5, 12)
                },
                new Employee
                {
                    Id = 2,
                    Name = "Priya",
                    Salary = 55000,
                    Permanent = false,
                    Department = new Department { Id = 2, Name = "HR" },
                    Skills = new List<Skill>
                    {
                        new Skill { Id = 3, Name = "Communication" }
                    },
                    DateOfBirth = new DateTime(2000, 8, 21)
                }
            };
        }

        // GET api/employee
        [HttpGet]
        [ProducesResponseType(200)]
        public ActionResult<List<Employee>> GetStandard()
        {
            return Ok(_employees);
        }

        // GET api/employee/throw  -> deliberately triggers CustomExceptionFilter
        [HttpGet("throw")]
        [ProducesResponseType(500)]
        public ActionResult<Employee> GetWithError()
        {
            throw new Exception("Deliberate test exception for CustomExceptionFilter");
        }

        // POST api/employee  -> demonstrates [FromBody]
        [HttpPost]
        [ProducesResponseType(200)]
        public ActionResult AddEmployee([FromBody] Employee newEmployee)
        {
            _employees.Add(newEmployee);
            return Ok("Employee added successfully");
        }

        // PUT api/employee/1  -> demonstrates [FromBody]
        [HttpPut("{id}")]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        public ActionResult UpdateEmployee(int id, [FromBody] Employee updatedEmployee)
        {
            var emp = _employees.FirstOrDefault(e => e.Id == id);
            if (emp == null)
                return BadRequest("Employee not found");

            emp.Name = updatedEmployee.Name;
            emp.Salary = updatedEmployee.Salary;
            emp.Permanent = updatedEmployee.Permanent;
            emp.Department = updatedEmployee.Department;
            emp.Skills = updatedEmployee.Skills;
            emp.DateOfBirth = updatedEmployee.DateOfBirth;

            return Ok("Employee updated successfully");
        }
    }
}