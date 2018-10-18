# hotmoto
Parkings : http://hotmoto.mr47.net/parkings
Insert: (POST):http://hotmoto.mr47.net/parkings
	example:
	cost va numberHours gía theo số lượng giờ ví dụ : 5$ / 4hour
    
    them loai xe vao: param: type(Int) 
    openTime va closeTime chuyen sang Int
  	{	
  		"id":"5af90325a0ccf74aec2269f1",
  		"location":{"type":"Point","coordinates":[106.65500421077,10.8401665597548]},
		"name":"1",
		"address":"test address",
		"phone":"012345",
		"total":14, 
		"AvailableSlot":0,
		"openTime":0,
		"closeTime":0,
		"status":1,
		"fullname":"Le An",
		"cost":10000,
		"numberHours":4,
		"userID":"1234",
		"username":"lean",
		"email":"leantompro@gmail.com",
		"imageUrl":"",
		"description_park":"",
		"type":0
  }

Get: (GET) : http://hotmoto.mr47.net/parkings

Get Parking theo Username: (POST) : http://hotmoto.mr47.net/parkings/users 

	{
		"username":"lean"
	}
Get Parking theo Username: (POST) : http://hotmoto.mr47.net/parkings/users 

	{
		"username":"lean"
	}
Update: (PUT): http://hotmoto.mr47.net/parkings

Update Slot: (POST): hotmoto.mr47.net/parkings/updateSlot

{
	
	"slot":4,
	"id_park":"5af90325a0ccf74aec2269f1"

}

Update Price: (POST): hotmoto.mr47.net/parkings/updateCost

{
	
	"cost":4,
	"id_park":"5af90325a0ccf74aec2269f1"

}

Delete: (DELETE): http://hotmoto.mr47.net/parkings

	{
	
      		"id": "5aa0b92b00ae4f5e4c326d2d"
		
	}
	
Get locations gần vị trí truyên vô:(POST) http://hotmoto.mr47.net/parkings/getNearCurrents 

{

	"position": [float,float]  
	"scope":(float)
	
}
Trong đó : Position:  (long,lat) 
Scope: Pham vi
// DANG NHAP

Login:(POST)   http://hotmoto.mr47.net/users/login 

	{
	
		"username":"lean",
		"password":"123"
		
	}
response data login :

	{
	    "id": "5afaae8ca0ccf760e2bc605c",
	    "username": "user1",
	    "password": "password1",
	    "devicetoken": "123"
	}
	
	
Register:(POST)   http://hotmoto.mr47.net/users/register

	{
	
		"username":"lean",
		"password":"123"
		
	}


PushNotification Single Device : http://hotmoto.mr47.net/api/pushNotificationSingle

	{
	
     		 "title": "Hello every body",
     		 "content": "Hello IOS push notification",
     		 "deviceToken": "86d4683d6da8fb7bee9cab9fdb0b7284a74c4cbc397c65e733786051b2b03f04"
    
	}
	
Response Data:

	{
    		"alert": "{\"aps\":{\"alert\":{\"title\":\"Hello every body\",\"body\":\"Hello IOS push 	notification\"},
		\"badge\":1,
		\"sound\":\"bingbong.aiff\"}}",
	  	"success": true,
	    	"error": null
	}
	
Register Devicetoken: hotmoto.mr47.net/api/registerDeviceToken

	{
		"userID":"5afaae8ca0ccf760e2bc605c",
		"deviceToken":"123"
	}
Delete Devicetoken: hotmoto.mr47.net/api/deleteDeviceToken

	{
		"userID":"5afaae8ca0ccf760e2bc605c"
	}	
