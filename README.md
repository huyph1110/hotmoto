# hotmoto
Parkings : http://hotmoto.mr47.net/parkings
Insert: (POST):http://hotmoto.mr47.net/parkings
	example:
	
	
  {
  
	"location":{
		"type":"Point",
		"coordinates":[106.65500421077,10.8401665597548]
		},
		
	"name":"test name",
	"address":"test address",
	"phone":"012345",
	"total":0,
	"AvailableSlot":0,
	"openTime":"",
	"closeTime":"",
	"status":1,
	"fullname":"Le An",
	"username":"lean",
	"email":"xuanquang48@gmail.com"		
  }

Get: (GET) : http://hotmoto.mr47.net/parkings

Get Parking theo Username: (POST) : http://hotmoto.mr47.net/parkings/users 

	{
		"username":"lean"
	}

Update: (PUT): http://hotmoto.mr47.net/parkings

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
	
	
Register:(POST)   http://hotmoto.mr47.net/users/register

	{
	
		"username":"lean",
		"password":"123"
		
	}
