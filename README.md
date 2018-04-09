# hotmoto
Parkings : http://hotmoto.mr47.net/parkings
Insert: (POST):http://hotmoto.mr47.net/parkings
	example:
    {
        "position": [10.2, 10.3],
        "name": "Hoang duong",
        "address": "75 Dong khoi ",
        "phone": "0904393114"
    }

Get: (GET) : http://hotmoto.mr47.net/parkings

Update: (PUT): http://hotmoto.mr47.net/parkings

Delete: (DELETE): http://hotmoto.mr47.net/parkings
	{
      		"id": "5aa0b92b00ae4f5e4c326d2d"
	}
Get locations gần vị trí truyên vô:(POST) http://hotmoto.mr47.net/parkings/getNearCurrents 
{
	"long": (float),
	"lat": (float),
	"scope":(float)
}
