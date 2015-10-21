
scrW, scrH = System.screenSize();

window.frame(0, 0, scrW, scrH);
window.backgroundColor(0xffffff,1);
window.enabled(true);



function createLaZhu(x,y)
	local lazhu = {};

	local percent = 1;
	local r = 40*percent;

	local bodyX0 = x;
	local bodyY0 = y;
	local fireArr = {};

    lazhu.lazhuBodyBG = View();
    lazhu.lazhuBody = Image();
    lazhu.lazhuBody.frame(0, 0, 64, 104);
    lazhu.lazhuBodyBG.frame( bodyX0 - 64*0.45, bodyY0 + r*0.5, 64, 104);
	lazhu.lazhuBody.image("lazhu.png");
    lazhu.lazhuBodyBG.addView(lazhu.lazhuBody);

	lazhu.onOff = true;
	lazhu.button = Button();
	lazhu.button.title("开/关");
	lazhu.button.backgroundColor(0xff0000,1);
	lazhu.button.frame(0, 50, 64, 60);
	lazhu.button.click( function()
		if( lazhu.onOff ) then
			lazhu.onOff = false;
		else
			lazhu.onOff = true;
			for index = 1, 20  do
				fireArr[index].showfires();
			end
		end
	end);
	lazhu.lazhuBodyBG.addView(lazhu.button);

	function lazhu.move( dx,dy )
	 	bodyX0 = bodyX0 + dx;
	 	bodyY0 = bodyY0 + dy;
		self.lazhuBodyBG.frame( bodyX0 - 64*0.45, bodyY0 + r*0.5, 64, 104);
	 end 


	-------------------------------
	function lazhu.fireCreater()
		local fire = {};
		fire.times = 0;

		fire.imageView1 = Image();
		fire.imageView2 = Image();
		fire.imageView1.image("color1.png");
		fire.imageView2.image("color2.png");
		fire.imageView1.frame(0,0,r*2,r*2);
		fire.imageView2.frame(0,0,r*2,r*2);

		fire.bg = View();
		fire.bg.frame(0,0,r*2,r*2);
		fire.bg.addView(fire.imageView1);
		fire.bg.addView(fire.imageView2);

		function fire.initX0Y0()
			self.bg.scale( 1, 1);
			self.bg.size( r*2, r*2);
			self.bg.alpha( 0.5);

			local x0 = math:random(bodyX0, bodyX0 + r*0.1);
			local y0 = math:random(bodyY0, bodyY0 + r*0.3);

			self.bg.center(x0,y0);
			self.x = x0;
			self.y = y0;

			self.imageView1.alpha( 1);
			self.imageView2.alpha( 0);
		end

		function fire.move()
			self.bg.center( self.x, self.y );
			self.bg.scale( 0.2, 0.4);
			self.imageView1.alpha(0);
			self.imageView2.alpha(1);
			self.bg.alpha(0);
		end

		function fire.nextXYAndColor()
			local len = 30*percent;
			local dx = math:random(-len,len);
			local maxDy = math:sqrt( (len*len*2 - dx*dx) )*2;
			local dy = math:random( -maxDy, 0 );
			local x,y = self.bg.center();
			self.x = x+dx;
			self.y = y+dy;
		end
		function fire.showfires()
			self.initX0Y0();
			self.nextXYAndColor();

			local time = math:random(7,10)/10.0;
			Animate(time,
				function ()
					self.move();
				end
				,
				function ()
					if( lazhu.onOff ) then
						self.showfires();
					end
				end
				);
		end

		return fire;
	end
	-------------------------------------

	local index = 1;
	lazhu.fireTimer = Timer(
		function()
			if (index<=20 ) then
			   	fireArr[index] = lazhu.fireCreater();
				fireArr[index].showfires();
				index = index+1;
			else
				lazhu.fireTimer.cancel();
			end
		end
	);

	lazhu.fireTimer.start(0.1, true);
	return lazhu;
end

lazhu1 = createLaZhu(50,200);
lazhu2 = createLaZhu(160,200);
lazhu3 = createLaZhu(260,200);



	dragGesture = PanGesture(
		function( g )
			local state = g.state();
			if( state == GestureState.BEGIN ) then
				 gestureX, gestureY = g.location();
			elseif( state == GestureState.CHANGED ) then
				 local x, y = g.location();
				 local dx = x- gestureX;
				 local dy = y- gestureY;
				 gestureX = x;
				 gestureY = y;
				 lazhu2.move(dx,dy);
			end
		end
	);

	window.addGesture(dragGesture);
