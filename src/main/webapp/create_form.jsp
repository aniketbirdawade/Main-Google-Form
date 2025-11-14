<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Create New Form</title>
	<style>
	body
	{
	font-family: Arial, sans-serif;
	background-color: #f9fafb;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	}
	form 
	{
	background: white;
	padding: 30px;
	border-radius: 12px;
	box-shadow: 0 2px 8px rgba(0,0,0,0.1);
	width: 400px;
	}
	input, textarea
	{
	width: 100%;
	padding: 10px;
	margin-top: 10px;
	border: 1px solid #ccc;
	border-radius: 6px;
	}
	button 
	{
	margin-top: 15px;
	padding: 10px 20px;
	background-color: grey;
	border: none;
	color: white;
	border-radius: 6px;
    cursor: pointer;
	}
	button:hover
	{
	background-color: #0056b3;
	}
	</style>
</head>
<body>

    <form action="CreateFormServlet" method="post">
  	<h2>Create a New Form</h2>
        <label>Form Title:</label>
        <input type="text" name="title" required>

        <label>Description:</label>
        <textarea name="description" rows="3"></textarea>

        <label>Created By:</label>
        <input type="text" name="created_by" required>

        <button type="submit">Create Form</button>
    </form>

</body>
</html>
