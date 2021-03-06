<%@ page language="java" pageEncoding="UTF-8" session="true" %>
<%@ page import="model.Candidate" %>
<%@ page import="model.Photo" %>
<%@ page import="store.PsqlStore" %>
<%@ page import="model.City" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
            integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
            integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
            integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
            crossorigin="anonymous"></script>

    <title>Работа мечты</title>
    <link rel="icon" type="image/png" href="/dreamjob/favicon.ico"/>

</head>
<body onload="getCities()">
<%
    String id = request.getParameter("id");
    Candidate candidate = new Candidate(0, "", 0, 0);
    Photo photo = new Photo(0, "");
    City city = new City(0, "");
    if (id != null) {
        candidate = PsqlStore.instOf().findCandidateById(Integer.parseInt(id));
        if (candidate != null) {
            if (candidate.getPhoto() != null) {
                photo = candidate.getPhoto();
            }
            if (candidate.getCity() != null) {
                city = candidate.getCity();
            }
        }
    }

%>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script>
    function getCities() {
        $.ajax({
            type: "GET",
            url: "http://localhost:8080/dreamjob/city.do?list=true",
            dataType: 'json',
            origin: "http://localhost:8081"
        })
            .done(function (data) {
                var cityId = <%=city.getId()%>;
                let cities = "<option value=\"\"></option>";
                for (let i = 0; i < data.length; i++) {
                    if (cityId === data[i]['id']) {
                        cities += "<option value=" + data[i]['id'] + " selected>" + data[i]['name'] + "</option>";
                    } else {
                        cities += "<option value=" + data[i]['id'] + ">" + data[i]['name'] + "</option>";
                    }
                }
                $('#city').html(cities);
            })
            .fail(function (err) {
                alert("err" + err.message);
            })
    }

</script>
<div class="container pt-3">
    <div class="row">
        <ul class="nav">
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/posts.do">Вакансии</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/candidates.do">Кандидаты</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/post/edit.jsp">Добавить вакансию</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/candidate/edit.jsp">Добавить кандидата</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/city.do">Города</a>
            </li>
            <li class="nav-item">
                <% if (request.getAttribute("user") != null) {%>
                <a class="nav-link" href="<%=request.getContextPath()%>/login.jsp"> <c:out value="${user.name}"/> |
                    Выйти</a>
                <%} else {%>
                <a class="nav-link" href="<%=request.getContextPath()%>/login.jsp">Войти</a>
                <%}%>
            </li>
        </ul>
    </div>
    <div class="row">
        <div class="card" style="width: 100%">
            <div class="card-header">
                <% if (id == null) { %>
                Новый кандидат.
                <% } else { %>
                Редактирование кандидата.
                <% } %>
            </div>
            <div class="card-body">
                <form action="<%=request.getContextPath()%>/candidates.do?id=<%=candidate.getId()%>" method="post"
                      enctype="multipart/form-data">
                    <div class="form-group">
                        <label>Имя</label>
                        <input type="text" class="form-control" name="name" value="<%=candidate.getName()%>">
                        <a href="<%=request.getContextPath()%>/download?path=<%=photo.getPath()%>">Download</a>
                        <img src="<%=request.getContextPath()%>/download?path=<%=photo.getPath()%>" width="100px"
                             height="100px"/>
                    </div>
                    <div class="checkbox">
                        <input type="file" class="form-control" name="image">
                    </div>
                    <div class="form-group">
                        <label for="city">Город:</label>
                        <select class="form-control" id="city" name="cityId">
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Сохранить</button>
                    <button type="button" class="btn btn-primary" name="back" onclick="history.back()">back</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>