package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.ui.FlxButton;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnTextESP:FlxText;
	var warnTextENG:FlxText;

	var textKeys:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		textKeys = new FlxText(0, 90, FlxG.width,"<-- ENG ESP -->",32);
		textKeys.setFormat("VCR OSD Mono", 32, FlxColor.RED, CENTER);
		textKeys.screenCenter(X);
		add(textKeys);

		warnTextESP = new FlxText(0, 0, FlxG.width,
			"OYE!\n
			ESTE MOD TIENE LUCES PARPADEANTES!\n
			PRESIONA ENTER PARA DESACTIVARLAS\n
			O PRESIONA ESCAPE PARA IGNORAR ESTE MENSAJE\n
			HAS SIDO ADVERTIDO",
			32);
		warnTextESP.setFormat("VCR OSD Mono", 32, FlxColor.RED, CENTER);
		warnTextESP.screenCenter(Y);
		add(warnTextESP);
		warnTextESP.alpha = 1;
		warnTextENG = new FlxText(0, 0, FlxG.width,
			"Hey, watch out!\n
			This Mod contains some flashing lights!\n
			Press ENTER to disable them now or go to Options Menu.\n
			Press ESCAPE to ignore this message.\n
			You've been warned!",
			32);
		warnTextENG.setFormat("VCR OSD Mono", 32, FlxColor.RED, CENTER);
		warnTextENG.screenCenter(Y);
		add(warnTextENG);
		warnTextENG.alpha = 0;
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.LEFT)
			{
				warnTextENG.alpha = 1;
				warnTextESP.alpha = 0;
			}
		if (FlxG.keys.justReleased.RIGHT)
			{
				warnTextENG.alpha = 0;
				warnTextESP.alpha = 1;
			}
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnTextESP, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
					FlxFlicker.flicker(warnTextENG, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnTextESP, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							textKeys.alpha = 1;
							MusicBeatState.switchState(new TitleState());
						}
					});
					FlxTween.tween(warnTextENG, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							textKeys.alpha = 1;
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
