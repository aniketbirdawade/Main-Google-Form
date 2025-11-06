<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Questions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9fafb;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        form {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            width: 400px;
        }
        input, select, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #28a745;
            border: none;
            color: white;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover {
            background-color: #1e7e34;
        }
    </style>
</head>
<body>

    <form action="AddQuestionServlet" method="post">
        <h2>Add a Question</h2>

        <label>Form ID:</label>
        <input type="number" name="form_id" required placeholder="Enter form ID">

        <label>Question Text:</label>
        <textarea name="question_text" rows="3" required></textarea>

        <label>Question Type:</label>
        <select name="question_type" required>
            <option value="text">Text</option>
            <option value="radio">Multiple Choice (Radio)</option>
            <option value="checkbox">Checkbox</option>
        </select>

        <button type="submit">Add Question</button>
    </form>

</body>
</html>
