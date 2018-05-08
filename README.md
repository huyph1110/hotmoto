# hotmoto
Parkings : http://hotmoto.mr47.net/parkings
Insert: (POST):http://hotmoto.mr47.net/parkings
	example:
   {
        "location": {
    		"type": "Point",
    		"coordinates": [73.5, 40.4]
		},
        "name": "Hoang duong",
        "address": "75 Dong khoi ",
        "phone": "0904393114",
        "total":4
    }

Get: (GET) : http://hotmoto.mr47.net/parkings

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

Login:(POST)   http://hotmoto.mr47.net//users/login 
	{
		"username":"lean",
		"password":"123"
	}
Register:(POST)   http://hotmoto.mr47.net//users/register
	{
		"username":"lean",
		"password":"123"
	}
