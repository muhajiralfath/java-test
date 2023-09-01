<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome Page</title>
    <link rel="stylesheet" type="text/css" href="welcome.css">
</head>
<body>
<div class="container">
    <%
        String[][] studentDetails = {
                { "Dep 1", "S1", "35", "", "John Smith" },
                { "Dep 1", "S2", "70", ""," Jane Doe" },
                { "Dep 1", "S3", "60", "", "Michael Johnson" },
                { "Dep 1", "S4", "90", "", "Emily Brown" },
                { "Dep 2", "S5", "30", "", "David Lee" },
                { "Dep 3", "S6", "32", "", "Sarah Wang" },
                { "Dep 3", "S7", "70", "", "Chris Johnson" },
                { "Dep 3", "S8", "20", "", "Michelle Davis" }
        };
        String validUsername = "admin";
        String validPassword = "admin";

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        boolean isLoggedIn = false;

        if (username != null && password != null) {
            if (username.equals(validUsername) && password.equals(validPassword)) {
                isLoggedIn = true;
                System.out.println("<h2>Login successful!</h2>");
            } else {
                System.out.println("<h2>Login failed. Invalid credentials.</h2>");
            }
        } else {
            System.out.println("<h2>Please enter your username and password.</h2>");
        }

        if (isLoggedIn) {
            for (int i = 0; i < studentDetails.length; i++) {
                String marksStr = studentDetails[i][2];
                int marks = Integer.parseInt(marksStr);
                studentDetails[i][3] = marks >= 40 ? "Pass" : "Fail";
            }
        }
    %>
    <h2>Welcome <%= username %></h2>
    <table>
        <tr>
            <th>Department</th>
            <th>Student ID</th>
            <th>Marks</th>
            <th>Pass %</th>
        </tr>
        <%
            String currentDepartment = "";
            for (int i = 0; i < studentDetails.length; i++) {
                String department = studentDetails[i][0];
                if (!currentDepartment.equals(department)) {
                    currentDepartment = department;
                    int rowspan = countRowsWithSameDepartment(i, studentDetails);
        %>
        <tr>
            <td rowspan="<%= rowspan %>"><%= department %></td>
            <td><a href="javascript:void(0);" onclick="showPopup('<%= studentDetails[i][4] %>')"><%= studentDetails[i][1] %></a></td>
            <td><%= studentDetails[i][2] %></td>
            <td rowspan="<%= rowspan %>"><%= formatPassPercentage(i, studentDetails) %></td>
        </tr>
        <% } else { %>
        <tr>
            <td><a href="javascript:void(0);" onclick="showPopup('<%= studentDetails[i][4] %>')"><%= studentDetails[i][1] %></a></td>
            <td><%= studentDetails[i][2] %></td>
        </tr>
        <% } } %>
    </table>
    <div id="popup" class="popup"></div>
</div>
<script>
    function showPopup(studentName) {
        var popupDiv = document.getElementById("popup");
        popupDiv.innerHTML = "Student Name: " + studentName;
        popupDiv.style.display = "block";
        setTimeout(function() {
            popupDiv.style.display = "none";
        }, 1000);
    }
</script>
</body>
</html>

<%-- Custom method to count rows with the same department name --%>
<%! int countRowsWithSameDepartment(int startIndex, String[][] arr) {
    String departmentName = arr[startIndex][0];
    int count = 0;
    for (int i = startIndex; i < arr.length; i++) {
        if (arr[i][0].equals(departmentName)) {
            count++;
        }
    }
    return count;
} %>

<%-- Custom method to calculate pass percentage for each department --%>
<%! double calculatePassPercentage(int startIndex, String[][] arr) {
    String departmentName = arr[startIndex][0];
    int totalStudents = 0;
    int passedStudents = 0;
    for (int i = startIndex; i < arr.length; i++) {
        if (arr[i][0].equals(departmentName)) {
            totalStudents++;
            if (arr[i][3].equals("Pass")) {
                passedStudents++;
            }
        }
    }
    return totalStudents > 0 ? (double) passedStudents / totalStudents * 100 : 0;
} %>

<%-- Custom method to format pass percentage with two decimal places --%>
<%! String formatPassPercentage(int startIndex, String[][] arr) {
    double passPercentage = calculatePassPercentage(startIndex, arr);
    return String.format("%.2f", passPercentage);
} %>

