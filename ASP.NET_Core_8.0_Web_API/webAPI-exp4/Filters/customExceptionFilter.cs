using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace WebApiExp3.Filters
{
    public class CustomExceptionFilter : IExceptionFilter
    {
        public void OnException(ExceptionContext context)
        {
            string logPath = Path.Combine(Directory.GetCurrentDirectory(), "exception_log.txt");
            string logEntry = $"{DateTime.Now}: {context.Exception.Message}{Environment.NewLine}{context.Exception.StackTrace}{Environment.NewLine}---{Environment.NewLine}";

            File.AppendAllText(logPath, logEntry);

            context.Result = new ObjectResult(new
            {
                error = "Internal Server Error",
                message = context.Exception.Message
            })
            {
                StatusCode = 500
            };

            context.ExceptionHandled = true;
        }
    }
}