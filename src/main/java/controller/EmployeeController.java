package controller;

import dao.DepartmentDAO;
import dao.EmployeeDAO;
import model.Department;
import model.Employee;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/employee")
public class EmployeeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        EmployeeDAO employeeDAO = new EmployeeDAO();
        DepartmentDAO departmentDAO = new DepartmentDAO();

        List<Employee> employeeList = employeeDAO.getAllEmployees();
        List<Department> departmentList = departmentDAO.getAllDepartments();

        request.setAttribute("employeeList", employeeList);
        request.setAttribute("departmentList", departmentList);

        // Show top 5 highest paid only for manager
        if ("manager".equals(currentUser.getRole())) {
            List<Employee> top5 = employeeDAO.getTop5HighestPaid();
            request.setAttribute("top5List", top5);
        }

        // Handle edit: load employee to pre-fill form
        String editIdStr = request.getParameter("editId");
        if (editIdStr != null && !editIdStr.isEmpty()) {
            int editId = Integer.parseInt(editIdStr);
            Employee editEmp = employeeDAO.getEmployeeById(editId);
            // Only allow if current user is the creator
            if (editEmp != null && editEmp.getCreatedBy().equals(currentUser.getUsername())) {
                request.setAttribute("editEmployee", editEmp);
            }
        }

        request.getRequestDispatcher("/employee.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        String action = request.getParameter("action");
        EmployeeDAO employeeDAO = new EmployeeDAO();

        if ("add".equals(action)) {
            Employee emp = buildEmployeeFromRequest(request);
            emp.setCreatedBy(currentUser.getUsername());
            employeeDAO.addEmployee(emp);

        } else if ("update".equals(action)) {
            Employee emp = buildEmployeeFromRequest(request);
            emp.setId(Integer.parseInt(request.getParameter("id")));
            emp.setCreatedBy(currentUser.getUsername()); // enforce ownership in SQL
            employeeDAO.updateEmployee(emp);
        }

        response.sendRedirect(request.getContextPath() + "/employee");
    }

    private Employee buildEmployeeFromRequest(HttpServletRequest request) {
        Employee emp = new Employee();
        emp.setName(request.getParameter("name"));
        emp.setGender(request.getParameter("gender"));
        emp.setSalary(Double.parseDouble(request.getParameter("salary")));
        emp.setDeptId(Integer.parseInt(request.getParameter("deptId")));
        return emp;
    }
}
