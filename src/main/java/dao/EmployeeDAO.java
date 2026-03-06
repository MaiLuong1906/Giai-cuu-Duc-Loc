package dao;

import model.Employee;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    public List<Employee> getAllEmployees() {
        List<Employee> list = new ArrayList<>();
        String sql = "SELECT e.id, e.name, e.gender, e.salary, e.dept_id, d.name AS deptName, e.created_by "
                + "FROM employees e JOIN departments d ON e.dept_id = d.id "
                + "ORDER BY e.id";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Employee emp = mapRow(rs);
                list.add(emp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Employee getEmployeeById(int id) {
        String sql = "SELECT e.id, e.name, e.gender, e.salary, e.dept_id, d.name AS deptName, e.created_by "
                + "FROM employees e JOIN departments d ON e.dept_id = d.id WHERE e.id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addEmployee(Employee emp) {
        String sql = "INSERT INTO employees (name, gender, salary, dept_id, created_by) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getName());
            ps.setString(2, emp.getGender());
            ps.setDouble(3, emp.getSalary());
            ps.setInt(4, emp.getDeptId());
            ps.setString(5, emp.getCreatedBy());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateEmployee(Employee emp) {
        String sql = "UPDATE employees SET name=?, gender=?, salary=?, dept_id=? WHERE id=? AND created_by=?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getName());
            ps.setString(2, emp.getGender());
            ps.setDouble(3, emp.getSalary());
            ps.setInt(4, emp.getDeptId());
            ps.setInt(5, emp.getId());
            ps.setString(6, emp.getCreatedBy());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Employee> getTop5HighestPaid() {
        List<Employee> list = new ArrayList<>();
        String sql = "SELECT TOP 5 e.id, e.name, e.gender, e.salary, e.dept_id, d.name AS deptName, e.created_by "
                + "FROM employees e JOIN departments d ON e.dept_id = d.id "
                + "ORDER BY e.salary DESC";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Employee mapRow(ResultSet rs) throws SQLException {
        Employee emp = new Employee();
        emp.setId(rs.getInt("id"));
        emp.setName(rs.getString("name"));
        emp.setGender(rs.getString("gender"));
        emp.setSalary(rs.getDouble("salary"));
        emp.setDeptId(rs.getInt("dept_id"));
        emp.setDeptName(rs.getString("deptName"));
        emp.setCreatedBy(rs.getString("created_by"));
        return emp;
    }
}
