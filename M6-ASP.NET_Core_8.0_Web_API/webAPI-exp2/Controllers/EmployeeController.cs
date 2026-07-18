using Microsoft.AspNetCore.Mvc;
using FirstWebApi.Models;

namespace FirstWebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        private static List<Employee> _employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Akhil", Department = "Engineering" },
            new Employee { Id = 2, Name = "Priya", Department = "HR" },
            new Employee { Id = 3, Name = "Ravi", Department = "Finance" }
        };

        [HttpGet]
        [ProducesResponseType(200)]
        public ActionResult<IEnumerable<Employee>> Get()
        {
            return Ok(_employees);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        public ActionResult<Employee> Get(int id)
        {
            var emp = _employees.FirstOrDefault(e => e.Id == id);
            if (emp == null)
                return BadRequest("Employee not found");

            return Ok(emp);
        }
    }
}