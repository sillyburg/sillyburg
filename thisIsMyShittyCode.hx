// this was from like 2025 this isn't how i code now

import StringTools;
import funkin.savedata.FunkinSave;
import funkin.backend.chart.Chart;

var SAVESS:FunkinSave;
var songs:Array<ChartMetaData> = [];
var remixes:Array<ChartMetaData> = [];
var blur:CustomShader = new CustomShader('gaussian_blur');
var songsListCam:FlxCamera = new FlxCamera();
var highScoreCam:FlxCamera = new FlxCamera();
var songsTxts = [];
var songList = CoolUtil.coolTextFile('assets/categories/' + data.categories[data.song] + '/songsList.txt');
var curSelected = 0;
var curDiffSelected = 0;
var missesTxt:FlxText = new FlxText(0,0);
var extraTxt:FlxText = new FlxText(0,0);
var currentTween:FlxTween;
var canPress:Bool = false;

var offsetX = -190;

#if mobile
var isMobile = true;
var up:FlxSprite = new FlxSprite();
var down:FlxSprite = new FlxSprite();
var left:FlxSprite = new FlxSprite();
var right:FlxSprite = new FlxSprite();
var confirm:FlxSprite = new FlxSprite();
var credits:FlxText = new FlxText();
#else
var isMobile = false;
#end

blur.distort = 25;

function postCreate(){
    camera.addShader(blur);

    FlxG.cameras.add(songsListCam, false);
    songsListCam.bgColor = 0;

    FlxG.cameras.add(highScoreCam, false);
    highScoreCam.bgColor = 0;

    for (i in 0...songList.length){
        if (StringTools.contains(songList[i], ':::')){
            meow = songList[i].split(':::');
            songs.push(meow);
        } else {
            songs.push(songList[i]);
        }
    }

    trace(remixes);

    if (isMobile){
        down.frames = Paths.getSparrowAtlas('shadNotes');
        down.animation.addByPrefix("down","arrowDOWN", 10, true);
        down.animation.addByPrefix("downC","down confirm", 24, false);
        down.animation.play('down');
        down.camera = highScoreCam;
        down.scale.x /= 1.3;
        down.scale.y /= 1.3;
        down.screenCenter();

        up.frames = Paths.getSparrowAtlas('shadNotes');
        up.animation.addByPrefix("up","arrowUP", 10, true);
        up.animation.addByPrefix("upC","up confirm", 24, false);
        up.animation.play('up');
        up.camera = highScoreCam;
        up.scale.x /= 1.3;
        up.scale.y /= 1.3;
        up.screenCenter();

        left.frames = Paths.getSparrowAtlas('shadNotes');
        left.animation.addByPrefix("left","arrowLEFT", 10, true);
        left.animation.addByPrefix("leftC","left confirm", 24, false);
        left.animation.play('left');
        left.camera = highScoreCam;
        left.scale.x /= 2;
        left.scale.y /= 2;
        left.screenCenter();

        right.frames = Paths.getSparrowAtlas('shadNotes');
        right.animation.addByPrefix("right","arrowRIGHT", 10, true);
        right.animation.addByPrefix("rightC","right confirm", 24, false);
        right.animation.play('right');
        right.camera = highScoreCam;
        right.scale.x /= 2;
        right.scale.y /= 2;
        right.screenCenter();

        confirm.frames = Paths.getSparrowAtlas('shadNotes');
        confirm.animation.addByPrefix("confirm","E press", 10, true);
        confirm.animation.addByPrefix("confirmC","E confirm", 24, false);
        confirm.animation.play('confirm');
        confirm.camera = highScoreCam;
        confirm.scale.x /= 1.3;
        confirm.scale.y /= 1.3;
        confirm.screenCenter();
        confirm.x += 235;
        confirm.y += 100;

        up.x += 510;
        up.y += 50;
        down.x += 510;
        down.y += 250;
        left.y += 315;
        left.x += 145;
        right.y += 315;
        right.x += 165 + 170;

        credits.text = 'Credits';
        credits.size = 50;
        credits.font = Paths.font('Phantomuff Difficult Font.ttf');
        credits.camera = highScoreCam;
        credits.screenCenter();
        credits.y -= 300;
        FlxTween.tween(credits, {alpha: 0}, 3, {type: FlxTween.PINGPONG});

        for (i in [up, down, left, right, credits, confirm]){
            add(i);
            i.x -= 180;
            i.updateHitbox();
            i.offset.x += offsetX - 18.5;
            i.offset.y = -4;
        }

        for (i in [left, right]){
            i.offset.y = 0;
            i.offset.x -= 19;
        }
    }

    missesTxt.text = '';
    missesTxt.size = 50;
    missesTxt.offset.x = -150;
    missesTxt.offset.y = 250;
    missesTxt.font = Paths.font('AS.ttf');
    missesTxt.cameras = [highScoreCam];
    missesTxt.screenCenter();

    extraTxt.text = "< " + Std.string(Chart.loadChartMeta(songs[curSelected]).difficulties[curDiffSelected].charAt(0).toUpperCase()) + StringTools.replace(Chart.loadChartMeta(songs[curSelected]).difficulties[curDiffSelected], Chart.loadChartMeta(songs[curSelected]).difficulties[curDiffSelected].charAt(0), '') + ' >';
    extraTxt.size = 50;
    extraTxt.offset.x = -235;
    extraTxt.offset.y = -250;
    extraTxt.font = Paths.font('AS.ttf');
    extraTxt.cameras = [highScoreCam];
    extraTxt.screenCenter();

    var blackBehind = new FlxSprite(0, -200).makeGraphic(FlxG.width, FlxG.height * (songs.length + 2), FlxColor.BLACK);
    blackBehind.alpha = 0.5;
    blackBehind.cameras = [songsListCam];

    add(blackBehind);
    add(missesTxt);
    add(extraTxt);

    var meow = 0;
    trace(songs[2]);
    for (i in 0...songList.length){
        songName = new FlxText(0, 0);
        songName.size = 50;
        songName.font = Paths.font('AS.ttf');
        songName.text = (StringTools.contains(songList[i], ':::') ? songs[i][0] + ' >': Chart.loadChartMeta(songs[i]).displayName);
        songName.cameras = [songsListCam];
        songName.screenCenter(FlxAxes.Y);
        songName.alignment = 'left';
        songName.y += meow;
        meow += 50;
        songName.offset.x = -90;
        songName.autoSize = true;
        add(songName);
        songsTxts.push(songName);
    }
    currentTween = FlxTween.tween(songsTxts[curSelected], {'offset.x': songsTxts[curSelected].offset.x - 30}, 0.5, {ease: FlxEase.backOut});
    new FlxTimer().start(0.1, function(){
        canPress = true;
    });
}

function changeSelection(e){
    curSelected = FlxMath.wrap(curSelected + e, 0, songsTxts.length - 1);
    currentTween?.cancel();
    currentTween?.destroy();
    for (i in songsTxts){
        i.offset.x = -90;
    }
    currentTween = FlxTween.tween(songsTxts[curSelected], {'offset.x': songsTxts[curSelected].offset.x - 30}, 0.5, {ease: FlxEase.backOut});
    
    CoolUtil.playMenuSFX(0);
    curDiffSelected = 0;
    changeDiffSelection(1);
}

function changeDiffSelection(e){
    songList2 = CoolUtil.coolTextFile('assets/categories/' + data.categories[data.song] + '/songsList.txt');

    if (StringTools.contains(songList2[curSelected], ':::')){
        difficulties = songList2[curSelected].split(':::');
        trace(difficulties);
        
        curDiffSelected = FlxMath.wrap(curDiffSelected + e, 1, difficulties.length - 1);
        extraTxt.text = '< ' + Chart.loadChartMeta(difficulties[curDiffSelected]).displayName.charAt(0).toUpperCase() + StringTools.replace(Chart.loadChartMeta(difficulties[curDiffSelected]).displayName, Chart.loadChartMeta(difficulties[curDiffSelected]).displayName.charAt(0), '') + ' >';
        // extraTxt.text = "< " + Std.string(Chart.loadChartMeta(difficulties[curDiffSelected]).charAt(0).toUpperCase()) + StringTools.replace(Chart.loadChartMeta(difficulties[curDiffSelected], difficulties[curDiffSelected].charAt(0), '')) + ' >';
        trace(extraTxt.text);
    } else {
        difficulties = Chart.loadChartMeta(songs[curSelected]);

        extraTxt.text = "< " + Std.string(difficulties.difficulties[curDiffSelected].charAt(0).toUpperCase()) + StringTools.replace(difficulties.difficulties[curDiffSelected], difficulties.difficulties[curDiffSelected].charAt(0), '') + ' >';
        curDiffSelected = FlxMath.wrap(curDiffSelected + e, 0, difficulties.difficulties.length - 1); 
    }
}

var intendedHS:Int = 0;
var intendedMISSES:Int = 0;

function postUpdate(e){
    songsListCam.scroll.y = FlxMath.lerp(songsListCam.scroll.y, songsTxts[curSelected].y - 360, 0.05);
    // trace(Math.floor(FlxMath.lerp(intendedHS, FunkinSave.getSongHighscore(songs[curSelected], Chart.loadChartMeta(songs[curSelected]).difficulties[curDiffSelected]).score, 0.35)));
    // trace(Math.floor(FlxMath.lerp(intendedHS, FunkinSave.getSongHighscore(songs[curSelected][curDiffSelected], Chart.loadChartMeta(songs[curSelected][curDiffSelected]).difficulties[0]).score, 0.35)));

    if (!StringTools.contains(songList[curSelected], ':::')) intendedHS = FunkinSave.getSongHighscore(songs[curSelected], Chart.loadChartMeta(songs[curSelected]).difficulties[curDiffSelected]).score;
    if (!StringTools.contains(songList[curSelected], ':::')) intendedMISSES = FunkinSave.getSongHighscore(songs[curSelected], Chart.loadChartMeta(songs[curSelected]).difficulties[curDiffSelected]).misses;
    
    if (StringTools.contains(songList[curSelected], ':::')) intendedHS = FunkinSave.getSongHighscore(songs[curSelected][curDiffSelected], Chart.loadChartMeta(songs[curSelected][curDiffSelected]).difficulties[0]).score;
    if (StringTools.contains(songList[curSelected], ':::')) intendedMISSES = FunkinSave.getSongHighscore(songs[curSelected][curDiffSelected], Chart.loadChartMeta(songs[curSelected][curDiffSelected]).difficulties[0]).misses;
    missesTxt.text =
    'Highscore: ' + '' +
    '\nMisses: ' + intendedMISSES;

    if (controls.ACCEPT && canPress){
        startSong();
    }

    if (FlxG.keys.justPressed.C) openSubState(new ModSubState('CreditsSubState', {selectedSong: songList[curSelected], selectedDiff: curDiffSelected}));

    if (controls.DOWN_P) changeSelection(1);
    if (controls.UP_P) changeSelection(-1);
    if (controls.LEFT_P) changeDiffSelection(-1);
    if (controls.RIGHT_P) changeDiffSelection(1);
    if (controls.BACK) {close(); blur.distort = 0;}

    if (FlxG.mouse.justPressed && canPress && isMobile){
        if (FlxG.mouse.overlaps(down)) {
            changeSelection(1);
            down.animation.play('downC');
            down.offset.set(30 + offsetX, 30);
        }

        if (FlxG.mouse.overlaps(up)) {
            changeSelection(-1);
            up.animation.play('upC');
            up.offset.set(30 + offsetX, 30);
        }

        if (FlxG.mouse.overlaps(right)) {
            changeDiffSelection(1);
            right.animation.play('rightC');
            right.offset.set(15.5 + offsetX, 20);
        }

        if (FlxG.mouse.overlaps(left)) {
            changeDiffSelection(-1);
            left.animation.play('leftC');
            left.offset.set(15 + offsetX, 15);
        }

        if (FlxG.mouse.overlaps(confirm)) startSong();

        if (FlxG.mouse.overlaps(credits)) openSubState(new ModSubState('CreditsSubState', {selectedSong: songList[curSelected], selectedDiff: curDiffSelected}));
    }

    if (FlxG.mouse.justReleased && isMobile){
        if (FlxG.mouse.overlaps(down)) {
            down.animation.play('down');
            down.offset.set(0 + offsetX, 0);
        }

        if (FlxG.mouse.overlaps(up)) {
            up.animation.play('up');
            up.offset.set(0 + offsetX, 0);
        }

        if (FlxG.mouse.overlaps(left)) {
            left.animation.play('left');
            left.offset.set(0 + offsetX, 0);
        }

        if (FlxG.mouse.overlaps(right)) {
            right.animation.play('right');
            right.offset.set(0 + offsetX, 0);
        }
    }
}

function startSong(){
    songList2 = CoolUtil.coolTextFile('assets/categories/' + data.categories[data.song] + '/songsList.txt');

    if (StringTools.contains(songList2[curSelected], ':::')){
        song = Std.string(songs[curSelected][curDiffSelected]);
        trace(song);

        PlayState.loadSong(song, Chart.loadChartMeta(song).difficulties[0]);
    } else if (!StringTools.contains(songList2[curSelected], ':::')) {
        trace(songs[curSelected]);
        PlayState.loadSong(songs[curSelected], Chart.loadChartMeta(songs[curSelected]).difficulties[curDiffSelected]);
    }

    FlxG.switchState(new PlayState());
}
