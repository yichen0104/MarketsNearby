import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.io.*;

public class TestServlet extends HttpServlet {
    /**
     * Overriding doGet method to process GET in HttpServlet
     * @param req request
     * @param res response
     * @throws ServletException if exception occurred in Servlet
     * @throws IOException if exception occurred in IO
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException{
        res.setContentType("text/html");
        res.setCharacterEncoding("UTF-8");

        try (PrintWriter writer = res.getWriter()) {
            writer.println("<!DOCTYPE html><html>");
            writer.println("<head>");
            writer.println("<meta charset=\"UTF-8\" />");
            writer.println("<title>MyServlet.java:doGet(): Servlet code!</title>");
            writer.println("</head>");
            writer.println("<body>");
            writer.println("<h1>This is a simple java servlet.</h1>");
            writer.println("</body>");
            writer.println("</html>");
        }
    }
}
