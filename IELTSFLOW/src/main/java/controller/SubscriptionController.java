package controller;

import dao.SubscriptionPackageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SubscriptionPackage;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SubscriptionController", urlPatterns = {"/subscription"})
public class SubscriptionController extends HttpServlet {

    private SubscriptionPackageDAO dao;

    @Override
    public void init() {
        dao = new SubscriptionPackageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SubscriptionPackage> packages = dao.getAllActivePackages();
        request.setAttribute("packages", packages);
        request.getRequestDispatcher("/html/subscription.jsp").forward(request, response);
    }
}
