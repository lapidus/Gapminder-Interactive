package org.gapminder
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	import org.gapminder.Answer;
	import org.gapminder.Question;

	public class DatabaseController extends Object
	{
		
		private var responseDB:SQLConnection;
		private var stmt:SQLStatement;
		
		public var answer:Answer;
	
		public var uniqueGroup:String = "aaa" + Math.ceil(Math.random()*50000).toString();
		
		public function DatabaseController()
		{

			var dbFile:File = File.applicationStorageDirectory.resolvePath("responses_15_37.db");
			responseDB = new SQLConnection();
			responseDB.open(dbFile);
			
			stmt = new SQLStatement();
			stmt.sqlConnection = responseDB;
			
			
			stmt.text = " CREATE TABLE IF NOT EXISTS questions ( id TEXT PRIMARY KEY, alt1 TEXT, alt2 TEXT, correct INT ) ";			
			stmt.execute();
			
			stmt.text = " CREATE TABLE IF NOT EXISTS answers ( id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, question_id TEXT, response TEXT ) ";			
			stmt.execute();
			
			stmt.text = " CREATE TABLE IF NOT EXISTS users ( id TEXT PRIMARY KEY, unique_group TEXT, name TEXT, score INTEGER ) ";			
			stmt.execute();
		
		}
		
		
		public function handleAnswers(answers:Object, questionID:String, correct:int):Number {
				
			var totalAlt1:Number = 0;
			var totalAlt2:Number = 0;
			var totalAnswers:Number = 0;
			
			for (var user:String in answers) {
				
				totalAnswers++;
				
				//insert user if not exists
				stmt = new SQLStatement();
				stmt.sqlConnection = responseDB;
				stmt.text = " INSERT OR IGNORE into users (id, unique_group, name, score) values(?, ?, '', 0) ";
				stmt.parameters[0] = user + "_" + uniqueGroup;
				stmt.parameters[1] = uniqueGroup;
				stmt.execute();
				
				//add answer
				answer = new Answer();
				answer.user_id = user;
				answer.question_id = questionID;
				answer.response = answers[user];
				addAnswer(answer);
				
				//update user score
				if(answer.response == correct.toString()) {
					stmt = new SQLStatement();
					stmt.sqlConnection = responseDB;
					stmt.text = " Update users set score = score + 1 WHERE id = ? ";
					stmt.parameters[0] = user + "_" + uniqueGroup;
					stmt.execute();
				}
				
				if(answer.response == "1"){
					totalAlt1++;
				}
				else{
					totalAlt2++;
				}
			

			}
			
			return totalAlt1/totalAnswers;
			
		}
		
		
		protected function addAnswer(answer:Answer):void
		{
			stmt = new SQLStatement();
			stmt.sqlConnection = responseDB;
			stmt.text = "INSERT into answers (user_id, question_id, response) values(?,?,?)";
			stmt.parameters[0] = answer.user_id + "_" + uniqueGroup;
			stmt.parameters[1] = answer.question_id;
			stmt.parameters[2] = answer.response;
			stmt.execute();
		}
		
		public function getQuestions():Array
		{
			stmt = new SQLStatement();
			stmt.sqlConnection = responseDB;
			stmt.itemClass = Question;
			stmt.text = " SELECT * from questions ";
			stmt.execute();
			
			var questions:Array = stmt.getResult().data;	
			return questions;
		}
		
		
		private function getAnswers():void
		{
			stmt = new SQLStatement();
			stmt.sqlConnection = responseDB;
			
			stmt.itemClass = Answer;
			stmt.sqlConnection = responseDB;
			stmt.text = "SELECT * from answers";
			stmt.execute();
			//answers = new ArrayCollection(stmt.getResult().data);
		}
		
		
		
		
		
		public function getPercentageAlt1(id):Number
		{
			stmt = new SQLStatement();
			stmt.sqlConnection = responseDB;
			stmt.text = " SELECT count(*) from answers where question_id = ? and response = 1 ";
			stmt.parameters[0] = id;
			stmt.execute();
			trace(stmt.getResult().data[0]["count(*)"]);
			var alt1:Number = stmt.getResult().data[0]["count(*)"];	
			
			stmt = new SQLStatement();
			stmt.sqlConnection = responseDB;
			stmt.text = " SELECT count(*) from answers where question_id = ? ";
			stmt.parameters[0] = id;
			stmt.execute();
			
			var total:Number = stmt.getResult().data[0]["count(*)"];	
			
			return alt1/total;
		
		}
		
		
		public function getResults(){
		
			stmt = new SQLStatement();
			stmt.sqlConnection = responseDB;
			stmt.text = " SELECT * from users where unique_group = ? ";
			stmt.parameters[0] = uniqueGroup;
			stmt.execute();
			
			return stmt.getResult().data;
		
		}
		
		public function getBest(){
		
			stmt = new SQLStatement();
			stmt.sqlConnection = responseDB;
			stmt.text = " SELECT score from users where unique_group = ? order by score DESC limit 1 ";
			stmt.parameters[0] = uniqueGroup;
			stmt.execute();
			
			var score:int = stmt.getResult().data[0]["score"];	
		
			return score;
			
		}
		
		public function getAverage(){
			
			stmt = new SQLStatement();
			stmt.sqlConnection = responseDB;
			stmt.text = " SELECT AVG(score) as average from users where unique_group = ? ";
			stmt.parameters[0] = uniqueGroup;
			stmt.execute();
			
			var average:Number = stmt.getResult().data[0]["average"];	
			return average;
		
		}
		
		/*
		protected function onAddBtnClick(event:MouseEvent):void
		{
			var answer:Answer = new Answer();
			answer.user_id = user_id.text;
			answer.question_id = question_id.text;
			addAnswer(answer);
			getAnswers();
		}
		
		
		protected function onDeleteBtnClick(event:MouseEvent):void
		{
			//deleteAnswer(dg.selectedItem as Answer);
			getAnswers();
		}
		
		
		// Retrieve employees with a Select all call
		
		
		
		// Delete a row from the employee table
		protected function deleteAnswer(employee:Answer):void
		{
		var sqlDelete:String = "delete from employees where id=? and firstname=? and lastname=? and position=?";
		var stmt:SQLStatement = new SQLStatement();
		stmt.sqlConnection = responseDB;
		stmt.text = sqlDelete;
		stmt.parameters[0] = employee.id;
		stmt.parameters[1] = employee.firstname;
		stmt.parameters[2] = employee.lastname;
		stmt.parameters[3] = employee.position;
		stmt.execute();
		}
		*/
		
	}
}