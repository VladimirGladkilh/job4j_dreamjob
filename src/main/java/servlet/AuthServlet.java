package servlet;

import model.User;
import store.PsqlStore;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AuthServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        User user = PsqlStore.instOf().findUserByEmail(email);
        if ("root@local".equals(email) && "root".equals(password)) {
            HttpSession sc = req.getSession();
            User admin = new User();
            admin.setName("Admin");
            admin.setEmail(email);
            sc.setAttribute("user", admin);
            resp.sendRedirect(req.getContextPath() + "/posts.do");
        } else {
            if (user != null && user.getPassword().equals(password)) {
                HttpSession sc = req.getSession();
                sc.setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/index.do");
            } else {
                req.setAttribute("error", "Не верный email или пароль");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        }
    }
}