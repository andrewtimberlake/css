require "spec_helper"

module CSS
  describe RuleSet do
    let (:ruleset) { Parser.new.parse(fixture('style.css')) }

    it "should respond to #to_style" do
      ruleset.to_style.should == "body{margin:0;background:black url(../images/background.jpg) fixed;color:#333333;padding:5px}\n#logo{left:5px;position:absolute;z-index:100;top:5px}\n#container{position:relative;-webkit-box-shadow:1px 1px 5px #333333;margin-top:125px;background:rgba(255, 0.75) ;box-shadow:1px 1px 5px #333333;-moz-box-shadow:1px 1px 5px #333333;width:900px}\n#content{padding:30px 10px 20px 20px}\n#menu{position:absolute;right:0;top:0}\n#menu ul{margin-top:4px;list-style:none outside none}\n#menu ul li{float:left}\n#menu ul li a{color:black;text-decoration:none;font-size:120%;padding:4px 6px}\n#menu ul li a:hover{background:rgba(0, 0.5) ;color:white}"
    end
  end
end
