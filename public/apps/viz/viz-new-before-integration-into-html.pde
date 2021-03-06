Person persons[] = new Person[1];
boolean initialized = false;

//community values
int communityRating = 0;
  
//Some magic numbers
int CANVAS_W = 900;
int CANVAS_H = 700;
int CIRCLE_MARGIN = 50; //margin to keep betwen circle tangent and top of image
float CIRCLE_RADIUS = (CANVAS_H/2)-CIRCLE_MARGIN;       
int CIRCLE_X = CANVAS_W/2;
int CIRCLE_Y = CANVAS_H/2;
float CIRCLE_MOVEMENT = 0.005;

// Some notes
// Processing.js doesn't really cast objects, which is fine, generally as 
// javascript will figure out things. However, when using a hashmap, it actually
// translates to a javascript 'object' which doesn't have the method 'get' 
// but you can access key/value pairs as variables: object.var

  void setup() {
      frameRate(10);
      smooth();

      size(CANVAS_W,CANVAS_H);
      textSize(12);
      persons[0] = new Person(); //array needs to be initialized

      /* Development */
      /*
      //[{"user":{"id":1,"name":"Roberto Calderon"},"data":{"messages_sent":24,"checkins":2},"links":[{"user_id":2,"messages_sent":22,"messages_received":2,"reciprocity_ratio":11}]},{"user":{"id":2,"name":"John Black"},"data":{"messages_sent":2,"checkins":1},"links":[{"user_id":1,"messages_sent":2,"messages_received":22,"reciprocity_ratio":0}]},{"user":{"id":3,"name":"Dawood Mslw"},"data":{"messages_sent":0,"checkins":0},"links":[]}]
      //person 1
      HashMap item = new HashMap();
      HashMap<String,String> u = new HashMap<String,String>();
      u.put("id", "1");
      u.put("name", "Person 1"); 
      item.put ("user",u);     
      HashMap<String,String> d = new HashMap<String,String>();
      d.put("messages_sent", "1");
      d.put("checkins", "200"); 
      item.put ("data",d);           
      HashMap<String,String> l = new HashMap<String,String>();
      l.put("id", "2");
      l.put("messages_sent", "1");
      l.put("messages_received", "0");
      //l.put("reciprocity_ratio", "1");
      HashMap[] links = new HashMap[1];
      
      links[0] = l;
      item.put("links", links);      

      HashMap item2 = new HashMap();
      HashMap<String,String> u2 = new HashMap<String,String>();
      u2.put("id", "2");
      u2.put("name", "Person 2"); 
      item2.put ("user",u2);     
      HashMap<String,String> d2 = new HashMap<String,String>();
      d2.put("messages_sent", "100");
      d2.put("checkins", "25"); 
      item2.put ("data",d2);           
      HashMap<String,String> l2 = new HashMap<String,String>();
      l2.put("id", "1");
      l2.put("messages_sent", "10");
      l2.put("messages_received", "0");
      //l2.put("reciprocity_ratio", "0.5");
      HashMap[] links2 = new HashMap[1];
      links2[0] = l2;
      item2.put("links", links2);      


      HashMap[] data = new HashMap[2];
      data[0] = item;
      data[1] = item2;
      
      println(data);
      
      initCircles(data);     
      */
      /* End Development */
      
  }
  
  void draw() {
    background(255);
    
    if (initialized) {
      //drawPeopleLinks(); //draw all the links
      for (int p=0, end=persons.length; p<end;p++){
        	Person person = (Person) persons[p];
        	person.drawPersonLinks();
        	person.draw();	
      }
    }    
  }

  void mousePressed() {
    for (int p=0, end=persons.length; p<end;p++){
      Person person = (Person) persons[p];
      if (mouseX > person.x-20 && mouseX < person.x +20 && mouseY > person.y-20 && mouseY < person.y+20){
	person.links = true;
      }
    }
  }

  void mouseReleased() {
    for (int p=0, end=persons.length; p<end;p++){
      Person person = (Person) persons[p];
        person.links = false;
     
    }
  }


  void initCircles(HashMap dataObject[]) {
    persons = new Person[1]; //Delete array
    int numPoints = dataObject.length;
    float angleUnits=TWO_PI/float(numPoints);    
    for (int i=0; i< dataObject.length;i++) {               
      HashMap dataItem = new HashMap();
      dataItem = (HashMap) dataObject[i];
      //HashMap user = (HashMap) dataItem.get("user"); //development
      HashMap user = (HashMap) dataItem.user; //deployment
      //HashMap links[] = (HashMap[]) dataItem.get("links"); //development
      HashMap links[] = (HashMap[]) dataItem.links; //deployment
      //HashMap data = (HashMap) dataItem.get("data");//development
      HashMap data[] = (HashMap[]) dataItem.data; //deployment
      float angle = angleUnits*i;
      initPerson(user,data,links,angle);
    }      
    
  }
/* 
  //Unused and unchecked for now 
  void updateCircles(HashMap data[]){
    int rating = 0;  
    for (int i=0; i< data.length;i++) {         
      HashMap dataItem = (HashMap) data[i];     
      HashMap person = (HashMap) dataItem.get("person");//HashMap person = (HashMap) dataItem.person;      
      HashMap friends[] = (HashMap[]) dataItem.get("friends");//HashMap friends[] = (HashMap[]) dataItem.friends;      
      rating = rating  + (Integer) person.get("rating");//rating = rating  + person.rating;	      
      updatePerson(person,friends);
    }
    communityRating = rating; 
  }
*/

  void initPerson(HashMap user, HashMap data, HashMap links[], float angle) {
    Person per = new Person(user, data, links, angle);
    
    if (!initialized) { //if persons Array has not been initialized initialize       
      persons[0] = per;
      initialized = true;       
    } else {       
      //search if this person exists, if not, add.
      boolean exists = false;
      for (int i=0 ; i<persons.length;i++){
		  Person existent = (Person) persons[i];
  		  //if ( existent.id == new Integer((String)user.get("id")) ){ //development
                  if ( existent.id == (Integer) user.id ){ //deployment
		      exists = true;           
		      break;
		  }
      }
      if ( exists == false ) {          
	  	  persons = (Person[]) append(persons, per); //might cause problems in js
      }
		    
    }     
  }

/*
  //unused and unchecked
  void updatePerson(HashMap person, HashMap friends[]) {
	  if (!initialized) { //prevent crashes if run before init.
                        float angle = 0;
			initPerson(person,friends,angle);
	  } else {
		  //search if this person exists, if it does update
	      boolean exists = false;
	      for (int i=0 ; i<persons.length;i++){
			  Person existent = (Person) persons[i];
			  if ( existent.id == (Integer)person.id ){ //if exists update
			      persons[i].name = person.name; //just in case it's modified
			      persons[i].id = person.id; //just in case 
		              persons[i].rating = person.rating;				   
			      persons[i].friends = friends;				                  

			      int maxNodeRatio = (((height/2)-CIRCLE_MARGIN)*TWO_PI)/(persons.length/6) ; //biggest circle.      
			      float factor =  ( person.rating / communityRating ) * maxNodeRatio;                   	  			 
			      persons[i].r = int(factor);				
			  }
	      }	       
	  } 	  
    }
*/
  class Person {     
    HashMap friends[];
    int x,y,id,messages_sent,r; String name;
    float angle;
    boolean links;
    
    Person () {
    }
    
    Person (HashMap user, HashMap data, HashMap links[], float angle) {
      this.angle = angle;
      //this.id = new Integer((String)user.get("id")); //development
      this.id = (Integer)user.id; //deploiyment
      //this.name = (String)user.get("name");//development 
      this.name = (String)user.name; //deployment
      //this.messages_sent = new Integer((String)data.get("messages_sent"));//development 
      this.messgaes_sent = (Integer)data.messages_sent; //deployment
      this.friends = links;
      //this.r = new Integer((String)data.get("checkins"));//development 
      this.r = (Integer)data.checkins; //deployment
      if (this.r > 50)
        this.r = 50;
      this.links = false;
    }
	    
    void draw() {       
      if (this.links)
        drawPersonLinks();
      drawPerson();      
    }

    void drawPerson() {
      //stroke(255,69,0);
      stroke(60,179,113);
      fill(255,140,0);	      
      
      strokeWeight(2);
            
      //ATTEMPTING TO MOVE ON THE CIRCLE

      this.angle = this.angle+CIRCLE_MOVEMENT;
      if (this.angle>=TWO_PI) this.angle=0.0;
      
      x = int(CIRCLE_RADIUS*sin(angle)) + CIRCLE_X  ; //translate to left side with a marg 
      y = int(CIRCLE_RADIUS*cos(angle)) + CIRCLE_Y; //translate to center   
      
      ellipse(x,y,r,r);
      fill(0);
      text(name,x+(r/2)+2,y);
    }

    void drawPersonLinks() {
	//for each friend
	for (int f=0 ; f<this.friends.length;f++){         
	  HashMap friend = (HashMap) this.friends[f];
	  //if exists in our list of people available
	  for (int l=0; l<persons.length; l++){
	    Person existent = (Person) persons[l];    
	    //if ( new Integer((String)friend.get("id")) == existent.id) { //development 
            if ( (Integer)friend.id == existent.id) { //deployment

  	      float messages_sent = float(this.messages_sent);		
	      //float reciprocity = float(new Integer((String)friend.get("messages_received"))); //development
              float reciprocity = float((Integer)friend.messages_received); //deployment
	      float factor =  ( messages_sent / reciprocity ) * 10.0 ;                   
			      
	      int lineWeight = int(factor);                   
	      if (lineWeight > 10) lineWeight = 10; //max width is 10 pixels
	      strokeWeight(lineWeight);
	      line ( this.x, this.y, existent.x, existent.y);
	      break;
	    }                 
	  }                     
	}    
      }
 
  }

