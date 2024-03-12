	//전역 패키지 선언
	var efusioni = new Object();

	//축약 패키지
	// efusioni.* 대신에 쓸 패키지 지정
	// 프로젝트마다 달리 할 수 있다.
	var ef = efusioni;
	
	//efusioni.utils : 유틸 패키지 선언
	efusioni.utils = new Object();
	
	//Random 선언 시작
	efusioni.utils.Random = function() {
		/*
		 * 0 ~ n-1 사이의 랜덤정수를 반환
		 * 
		 * n : 범위
		 * size : 지정안하면 0 ~ n-1 사이의 정수 반환
		 *        지정하면 size 크기의 0 ~ n-1 사이의 중복되지 않는 정수 배열을 반환
		 *        
		 *        참고 : size > n 이면 n 크기의 배열 반환
		 */
		this.number = function(n, size) {
			if (size == null || size == undefined) {
				return parseInt(Math.random() * n);
			}
			else {
				var arr = new Array();
				while (arr.length < n) {
					var ran = parseInt(Math.random() * n);

					var isDuplicate = false;
					for (var i=0; i<arr.length; i++) {
						if (ran == arr[i]) {
							isDuplicate = true;
							break;
						}
					}

					if (!isDuplicate) {
						arr.push(ran);
					}
				}
				
				return arr;
			}
		};
	};
	//Random 선언 끝

	//Validator 선언 시작 --------------------------------------------------------
	/*
		Usage
		
		var v = null;
		$(function() {
			// 기본적으로 폼필드(add메쏘드) 검증리터럴은 페이지 초기화시 선언
			// maxlength, 숫자제한 입력등이 해당 폼객체에 자동으로 설정된다. 
			v = new ef.utils.Validator(document.form);
			v.add("name", {
				empty : "이름을 입력하지 않았습니다."
			})
			.add("age", {
				empty : "나이를 입력하지 않았습니다.",
				format : "numeric"
			});
			.add("ssn1", {
				empty : "주민등록번호를 입력하지 않았습니다.",
				min : 6,
				max : 6
			})
			.add("ssn2", {
				empty : "주민등록번호를 입력하지 않았습니다.",
				min : 7,
				max : 7
			})
		});
		
		function proc() {
			var ssn = $("#ssn1").val() + $("#ssn2").val();
			
			//text에 대한 검증리터럴은 검증(validate()) 바로 전에.
			v.addText(ssn, {
				format : "ssn",
				formatFail : function() {
					$("#ssn1").val("").focus();
					$("#ssn2").val("");
				}
			})
			if (v.validate()) document.form.submit();
		}
		
	*/
	efusioni.utils.Validator = function (form) {
		this.form = (form instanceof jQuery) ? form[0] : form; //DOM 객체
		this.validities = [];
	};
	
	/*
		폼 구성요소 객체에 대한 검증요소를 추가
		
		인자형식
		name : "필드명"
		validity
		{
			empty	: "알럿문구",	//값이 비어있거나, 선택이 안되어 있을경우의 알럿 메시지
			format	: "포맷",		//numeric(정수), real(실수), ssn(주민등록번호), phone(전화번호), email(이메일)
			min		: 최소길이,		//입력문자열 최소길이
			max		: 최대길이		//입력문자열 최대길이
		}
	*/
	efusioni.utils.Validator.prototype.add = function(name, validity) {
		var item = validity;
		item.name = name;
		this.validities.push(item);
		
		var obj = $("[name=" + name + "]", $(this.form));
		
		if (obj.length == 0) {
			alert("Validator error (" + name + "): " + name + " 속성이 존재하지 않습니다.");
			return;
		}
		
		var tag = $(obj[0]).prop("tagName");
		var type = $(obj[0]).attr("type");
		
		tag = (tag == null || tag == undefined) ? "" : tag;
		type = (type == null || tag == undefined) ? "" : type;
		
		if (type.toLowerCase() == "text" || type.toLowerCase() == "file" || type.toLowerCase() == "passowrd" || type.toLowerCase() == "tel") {
			if (this.isValuable(item.max)) {
				obj.attr("maxlength", item.max);
			}
		} 
		
		if (tag.toLowerCase() == "select") {
			if (this.isValuable(item.format)) {
				alert("Validator error (" + name + "): select tag에 format 속성이 올수 없습니다.");
				return;
			}
			if (this.isValuable(item.min)) {
				alert("Validator error (" + name + "): select tag에 min 속성이 올수 없습니다.");
				return;
			}
			if (this.isValuable(item.max)) {
				alert("Validator error (" + name + "): select tag에 max 속성이 올수 없습니다.");
				return;
			}
		}
		else if (tag.toLowerCase() == "textarea") {
			if (this.isValuable(item.format)) {
				alert("Validator error (" + name + "): textarea tag에 format 속성이 올수 없습니다.");
				return;
			}
		}
		else if (tag.toLowerCase() == "input") {
			if (type.toLowerCase() == "radio") {
				if (this.isValuable(item.format)) {
					alert("Validator error (" + name + "): radio button에 format 속성이 올수 없습니다.");
					return;
				}
				if (this.isValuable(item.min)) {
					alert("Validator error (" + name + "): radio button에 min 속성이 올수 없습니다.");
					return;
				}
				if (this.isValuable(item.max)) {
					alert("Validator error (" + name + "): radio button에 max 속성이 올수 없습니다.");
					return;
				}
			}
			else if (type.toLowerCase() == "checkbox") {
				if (this.isValuable(item.format)) {
					alert("Validator error (" + name + "): checkbox button에 format 속성이 올수 없습니다.");
					return;
				}
				if (this.isValuable(item.min)) {
					alert("Validator error (" + name + "): checkbox button에 min 속성이 올수 없습니다.");
					return;
				}
				if (this.isValuable(item.max)) {
					alert("Validator error (" + name + "): checkbox button에 max 속성이 올수 없습니다.");
					return;
				}
			}
			else if (type.toLowerCase() == "file") {
				if (this.isValuable(item.format)) {
					alert("Validator error (" + name + "): file에 format 속성이 올수 없습니다.");
					return;
				}
				if (this.isValuable(item.min)) {
					alert("Validator error (" + name + "): file에 min 속성이 올수 없습니다.");
					return;
				}
				if (this.isValuable(item.max)) {
					alert("Validator error (" + name + "): file에 max 속성이 올수 없습니다.");
					return;
				}				
			}
			else if (type.toLowerCase() == "password") {
				if (this.isValuable(item.format)) {
					alert("Validator error (" + name + "): password에 format 속성이 올수 없습니다.");
					return;
				}
			}
			else if (type.toLowerCase() == "text") {			
			}
			else if (type.toLowerCase() == "number") {			
			}
			else if (type.toLowerCase() == "hidden") {			
			}
			else if (type.toLowerCase() == "tel") {			
			}
			else {
				alert("Validator error (" + name + "): select, radio, checkbox, text, file, password, textarea가 아닌 컴포넌트입니다.");
				return;
			}
		}
		else {
			alert("Validator error (" + name + "): select, radio, checkbox, text, file, password, textarea가 아닌 컴포넌트입니다.");
			return;
		}
		
		if (this.isValuable(item.format)) {
			if (item.format != "numeric" && item.format != "real" && item.format != "ssn" && item.format != "phone" && item.format != "email") {
				alert("Validator error (" + name + "): " + item.format + "란 format 옵션은 존재하지 않습니다.");
				return;
			}
		}

		var v = this;
		if (type.toLowerCase() == "text") {
			if (this.isValuable(item.format)) {
				if (item.format == "numeric") {
					obj.css("ime-mode", "disabled");
					obj.keypress(function(e) {
						if (e.keyCode < 48 || e.keyCode > 57) {
							v.preventDefault(e);
						}
					});
				}
				else if (item.format == "real") {
					obj.css("ime-mode", "disabled");
					obj.keypress(function(e) {
						if ((e.keyCode < 48 || e.keyCode > 57) && e.keyCode != 46) {
							v.preventDefault(e);
						}
					});
				}
				else if (item.format == "ssn") {
					obj.css("ime-mode", "disabled");
					obj.keypress(function(e) {
						if ((e.keyCode < 48 || e.keyCode > 57) && e.keyCode != 45) {
							v.preventDefault(e);
						}
					});
				}
				else if (item.format == "phone") {
					obj.css("ime-mode", "disabled");
					obj.keypress(function(e) {
						if ((e.keyCode < 48 || e.keyCode > 57) && e.keyCode != 45) {
							v.preventDefault(e);
						}
					});
				}
			}
		}

		return this;
	};
	
	/*
		값에 대한 검증요소를 추가
		
		인자형식
		text : "검증할 문자열"
		validity
		{
			empty		: "알럿문구",	//값이 비어있거나, 선택이 안되어 있을경우의 알럿 메시지
			format		: "포맷",		//numeric(정수), real(실수), ssn(주민등록번호), phone(전화번호), email(이메일)
			formatFail	: 포맷이 실패 했을 경우의 후처리 callback. 포맷관련 alert이 뜬 후, 실행된다.
			min			: 최소길이,		//입력문자열 최소길이
			max			: 최대길이		//입력문자열 최대길이
		}
	*/
	efusioni.utils.Validator.prototype.addText = function(text, validity) {
		var item = validity;
		item.text = text;
		this.validities.push(item);
		
		if (this.isValuable(item.format)) {
			if (item.format != "numeric" && item.format != "real" && item.format != "ssn" && item.format != "phone" && item.format != "email") {
				alert("Validator error : " + item.format + "란 format 옵션은 존재하지 않습니다.");
				return;
			}
		}

		return this;
	};
	
	efusioni.utils.Validator.prototype.preventDefault = function(e) {
	    if(e.preventDefault) {
	    	e.preventDefault();
	    }
	    else e.stop();

	    e.returnValue = false;
	    e.stopPropagation();
	};

	efusioni.utils.Validator.prototype.isValuable = function(obj) {
		if (obj == null) return false;
		if (obj == undefined) return false;
		if (obj == "") return false;
		
		return true;
	};
	
	efusioni.utils.Validator.prototype.validate = function() {
		for (var i=0; i<this.validities.length; i++) {
			var item = this.validities[i];
			if (item.name != null && item.name != undefined) {
				var obj = $("[name=" + item.name + "]", $(this.form));
				var tag = $(obj[0]).prop("tagName");
				var type = $(obj[0]).attr("type");
				
				tag = (tag == null) ? "" : tag;
				type = (type == null) ? "" : type;

				if (tag.toLowerCase() == "select") {
					if (this.isValuable(item.empty)) {
						if ($.trim(obj.val()) == "" ) {
							alert(item.empty);
							obj.focus();
							return false;
						}
					}
				}
				else if (type.toLowerCase() == "radio" || type.toLowerCase() == "checkbox") {
					var isChecked = false;
					for (var j=0; j<obj.length; j++) {
						if (obj[j].checked) {
							isChecked = true;
							break;
						}
					}
					
					if (!isChecked) {
						alert(item.empty);
						return false;
					}
				}
				else if (type.toLowerCase() == "text" || type.toLowerCase() == "password" || type.toLowerCase() == "tel" || tag.toLowerCase() == "textarea"){
					if (type.toLowerCase() == "text" || type.toLowerCase() == "tel") {
						if (this.isValuable(item.format)) {
							if (!this.isValidFormat(obj, item.format, item.formatFail)) return false;
						}
					}
					
					if (this.isValuable(item.empty)) {
						if ($.trim(obj.val()) == "" ) {
							alert(item.empty);
							obj.focus();
							return false;
						}
					}
					
					if (this.isValuable(item.max)) {
						if (obj.val().length > item.max) {
							alert(item.max + "자 이상 입력할 수 없습니다.");
							obj.focus();
							return false;
						}
					}
					if (this.isValuable(item.min)) {
						if (obj.val().length < item.min) {
							alert(item.min + "자 이하 입력할 수 없습니다.");
							obj.focus();
							return false;
						}
					}
				}				
				else if (type.toLowerCase() == "file") {
					if (this.isValuable(item.empty)) {
						if ($.trim(obj.val()) == "" ) {
							alert(item.empty);
							obj.focus();
							return false;
						}
					}
				}
			}
			else if (item.text != null && item.text != undefined){
				if (this.isValuable(item.format)) {
					if (!this.isValidFormat(item.text, item.format, item.formatFail)) return false;
				}
			}
			else {
				alert("Validator error : form name 또는 text가 지정되지 않습니다.");
				return false;
			}
		}
		
		return true;
	};
	
	efusioni.utils.Validator.prototype.isValidFormat = function(obj, format, callback) {
		var text = null;
		var isFormObj = true;
		if (obj.val) {
			text = obj.val();
		}
		else {
			text = obj;
			isFormObj = false;
		}
		
		if (format == "numeric") {
			if ($.trim(text).search(/[^0-9]/) != -1) {
				alert("숫자만 입력 가능합니다.");
				if (isFormObj) obj.val("").focus();
				else callback();
				return false;
			}
		}
		else if (format == "real") {
			if ($.trim(text).search(/[^0-9\.]/) != -1) {
				alert("숫자만 입력 가능합니다.");
				if (isFormObj) obj.val("").focus();
				else callback();
				return false;
			}
		}
		else if (format == "ssn") {
		    var s = text;
		    s = s.replace(/\-/gi, "");
		    var isSSN = true;
		    
		    var sum = 0 ;
		    sum = s.charAt(0) * 2 + s.charAt(1) * 3 + s.charAt(2) * 4 + s.charAt(3) * 5 +
		          s.charAt(4) * 6 + s.charAt(5) * 7 + s.charAt(6) * 8 + s.charAt(7) * 9 +
		          s.charAt(8) * 2 + s.charAt(9) * 3 + s.charAt(10) * 4 + s.charAt(11) * 5;

		    if (sum == 0) isSSN = false;
		    else {
		        sum = 11 - sum % 11 ;
		        if (sum > 9) sum = sum - 10;

		        if (sum != s.charAt(12)) isSSN = false;
		    }
		    
		    if (!isSSN) {
				alert("올바른 주민등록 번호 형식이 아닙니다.");
				if (isFormObj) obj.val("").focus();
				else callback();
				return false;
		    }
		}
		else if (format == "email") {
			if ($.trim(text).search(/^((\w|[\-\.])+)@((\w|[\-\.])+)\.([A-Za-z]+)$/) < 0) {
				alert("올바른 이메일 형식이 아닙니다.");
				if (isFormObj) obj.val("").focus();
				else callback();
				return false;
			}
		}
		else if (format == "phone") {
			if ($.trim(text).search(/^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/) < 0) {
				alert("올바른 전화번호 형식이 아닙니다.");
				if (isFormObj) obj.val("").focus();
				else callback();
				return false;
			}
		}
		
		return true;
	};
	//Validator 선언 끝 --------------------------------------------------------

	//efusioni.visual : 비쥬얼 패키지 선언
	efusioni.visual = new Object();
	
	//Player 선언 시작 --------------------------------------------------------
	var efusioniPlayerId = 0;
	
	efusioni.visual.Player = function (ip) {
		/*private member*/
		var PLAYING_ON = 0;
		var PLAYING_PAUSED = 1;
		var PLAYING_STOPPED = 2;
		var PLAYING_DONE = 3;
		
		var mode = null;
		var source = null;
		var frame = null;
		var currentFrame = 0;
		var timer = null;
		var self = this;
		var status = PLAYING_STOPPED;
		var bRotate = false;
		var images = null;
		var length = null;
		var bLoaded = false;
		
		/*init parameter*/
		mode = (ip.mode == null) ? "serial" : ip.mode;
		if (mode == "serial") {
			source = ip.source;
			length = ip.length;
		}
		else frame = ip.frame;
		
		var step = ip.step;
		var width = ip.width;
		var height = ip.height;
		var duration = ip.duration;
		var container = ip.container;
		var mouseControll = ip.mouseControll;
		var mouseDirection = ip.mouseDirection;
		var loadCompleteCallback = ip.loadCompleteCallback;
		var frameAt = ip.frameAt;
		var playDone = ip.playDone;
		var bReverse = (ip.reverse == null) ? false : ip.reverse;

		/*Optional Value Settings*/
		if (step == null) step = 1;
		if (duration == null) duration = 1000;
		if (mouseControll == null) mouseControll = false;
		if (mouseControll) {
			if (mouseDirection == null) mouseDirection = "normal";
		}

		$(container).data("player", this);
		
		efusioniPlayerId++;
		
		var initX = 0;
		var stopFrame = 0;
		
		if (mouseControll) {
			$(container).mousedown(function(e) {
				e.preventDefault();
				initX = e.pageX - $(container).offset().left;
				stopFrame = currentFrame;
				
				$(document).mousemove(function(e) {
					e.preventDefault();
					var x = e.pageX - $(container).offset().left;
					x = x - initX;
					
					var frame = 0;
					if (mouseDirection == "reverse") {
						frame = length - parseInt(x / width * length);
					}
					else {
						frame = parseInt(x / width * length);
					}
					
					frame = self._mod(stopFrame + frame);
					self.drawFrame(frame);
				});
				
				$(document).mouseup(function() {
					$(document).unbind("mousemove");
				});
			});
		}
		
		this._mod = function(n) {
			if (n >=0) {
				return n % length;
			}
			else {
				return (n + 1) % length + length - 1;
			}
		};
		
		this._play = function() {
			if (timer != null) clearTimeout(timer);
			if (status == PLAYING_ON) {
				self.drawFrame(currentFrame);
				
				if (bReverse) {
					if (currentFrame == 0) {
						if (bRotate) {
							currentFrame = length - 1;
						}
						else {
							status = PLAYING_DONE;
					
							if (playDone != null) playDone(self);
							return;
						}
					}
					else {
						currentFrame--;
					}
				}
				else {
					if (currentFrame == length - 1) {
						if (bRotate) {
							currentFrame = 0;
						}
						else {
							status = PLAYING_DONE;
					
							if (playDone != null) playDone(self);
							return;
						}
					}
					else {
						currentFrame++;
					}
				}
			}
			else if (status == PLAYING_STOPPED) {
				return;
			}

			timer = setTimeout(self._play, duration);
		};
		
		this.drawFrame = function(frm) {
			if (mode == "serial") {
				var margin = frm * width;
				$("img", container).css("margin-left", "-" + margin + "px");
			}
			else {
				$("img", container).attr("src", images[frm].src);
			}
			currentFrame = frm;
			if (frameAt != null) {
				frameAt(self, currentFrame);
			}
		};
		
		this._preload = function() {
			if (mode == "frame") {
				images = new Array(parseInt(frame.length / step));
				for (var i=0; i<images.length; i++) {
					images[i] = new Image();
					images[i].src = frame[i * step];
				}
				length = images.length;

			}
		};
		
		this.size = function() {
			return length;
		};
		
		this.getImage = function(frameIdx) {
			return images[frameIdx].src;
		};
		
		this.setImage = function(frameIdx, frameSrc) {
			images[frameIdx].src = frameSrc;
		};
		
		this.isLoaded = function() {
			return bLoaded;
		};
		
		this.isReverse = function() {
			return bReverse;
		};
		
		this.setReverse = function(b) {
			bReverse = b;
		};
		
		this.isPlaying = function() {
			return (status == PLAYING_ON);
		};
		
		this.isStopped = function() {
			return (status == PLAYING_STOPPED);
		};
		
		this.isPaused = function() {
			return (status == PLAYING_PAUSED);
		};
		
		this.isDone = function() {
			return (status == PLAYING_DONE);
		};
		
		this.setDuration = function(d) {
			duration = d;
		};
		
		this.getContainer = function() {
			return container;
		};
		
		this.play = function() {
			if (bLoaded) {				
				status = PLAYING_ON;
				bRotate = false;
				
				currentFrame = 0;
				
				self._play();
			}
			else alert("Not Initialized");
		};
		
		this.rotate = function() {
			if (bLoaded) {
				status = PLAYING_ON;
				bRotate = true;
				
				currentFrame = 0;
				
				self._play();
			}
			else alert("Not Initialized");
		};
		
		this.pause = function() {
			status = PLAYING_PAUSED;
		};
		
		this.resume = function() {
			status = PLAYING_ON;
		};
		
		this.stop = function() {
			status = PLAYING_STOPPED;
			
			currentFrame = 0;
			self.drawFrame(0);
		};

		/*init process start*/
		if (mode == "serial") {
			$(container).html("<div style=' width:" + width + "px; height:" + height + "px; overflow:hidden;'><img src='" + source + "' width='" + (width * length) + "' height='" + height + "' id='efusioniPlayer" + efusioniPlayerId + "' style='margin-left:0px'></div>");
		}
		else {
			$(container).html("<img src='" + frame[0] + "' width='" + width + "' height='" + height + "' id='efusioniPlayer" + efusioniPlayerId + "'>");
		}
		this._preload();
				
		bLoaded = true;
		if (loadCompleteCallback != null) loadCompleteCallback(this);
		/*init process end*/
		
	};
	//Player 선언 끝 --------------------------------------------------------
	
	// efusioni.ui : UI 패키지 선언
	efusioni.ui = new Object();
	
	//UIManager 선언 시작 --------------------------------------------------------
	efusioni.ui._UIManager = function() {
		this.idx = 0;
		this.euis = new Array();
		this.MAX_ZINDEX = 100000;

		/*
			Document의 빈영역을 클릭했을 경우, 펼쳐진 SelectBox를 닫아준다.
		*/
		var self = this;
		$(document).click(function(e) {
			var isOnSelect = false;
			for (var i=0; i<self.euis.length; i++) {
				var obj = self.euis[i];
				if (obj.type == "SELECT" && obj.visualElement != null) {
					if ($(e.target).parents("#" + obj.visualElement.attr("id")).length) {
						isOnSelect = true;
					}
				}
			}
			
			if (!isOnSelect) {
				for (var i=0; i<self.euis.length; i++) {
					var obj = self.euis[i];
					if (obj.type == "SELECT" && obj.visualElement != null) {
						$(".euiSelectList", obj.visualElement).hide();
					}
				}
			}
		});
	};

	efusioni.ui._UIManager.prototype.add = function(euiObj) {
		this.euis[this.idx] = euiObj;
		euiObj.euiIdx = this.idx;
		
		this.idx++;
	};

	efusioni.ui._UIManager.prototype.get = function(idx) {
		return this.euis[idx];
	};

	efusioni.ui._UIManager.prototype.size = function() {
		return this.euis.length;
	};

	efusioni.ui._UIManager.prototype.updateUi = function(formElement) {
		var eui = $(formElement).data("eui");
		if (eui != null) eui.update();
	};

	efusioni.ui.UIManager = new efusioni.ui._UIManager();
	//UIManager 선언 끝 --------------------------------------------------------

	//UI Select 선언 시작 --------------------------------------------------------
	efusioni.ui.Select = function (formElement, visualTemplate) {
		/*Eui 공통 시작*/
		this.type = "SELECT";
		this.euiIdx = -1;
		this.formElement = formElement;
		this.visualElement = null;
		this.zIndex = null;

		this.formElement.data("eui", this);
		efusioni.ui.UIManager.add(this);
		/*Eui 공통 끝*/
		
		this.template = visualTemplate;
		
		this._init();
	};

	efusioni.ui.Select.prototype.render = function() {
		this._parse();

		
		this._setTitleListener();
		this._setItemListener();
	};

	efusioni.ui.Select.prototype.update = function() {
		this._parse();
		
		this._setTitleListener();
		this._setItemListener();
	};

	efusioni.ui.Select.prototype._init = function() {
		var tag = this.template.html;
		this.visualElement = $(tag);
		$(this.visualElement).attr("id", "eui_" + this.euiIdx);
		$(this.visualElement).attr("style", this.formElement.attr("style"));	
		
		this.formElement.hide();
		this.formElement.after(this.visualElement);
		$(this.visualElement).attr("class", this.template.visualClass);
		this.zIndex = $(this.visualElement).css("z-index");

		this._setBaseListener();
		
	};

	efusioni.ui.Select.prototype._parse = function() {
		var sItem = "";
		var className = "";
		$("option", this.formElement).each(function(i) {
			if($(this).attr('selected') == 'selected'){
				className = 'selected'
				selectIdx = i
			} else {
				className = ''
			}
			var _text = $(this).text();
			var _colorData = $(this).attr('data-color');
			_text = _text.replace("\\r\\n", "<br>");
			if($(this).parent().hasClass('selectColor')){
				if($(this).index() == 0){
					sItem += "<li class='"+className+"'><a href='#'> <em class='selectThum firstOption'></em>" + _text + "</a></li>";
				}else{
					sItem += "<li class='"+className+"'><a href='#'> <em class='selectThum' style='background:#"+ _colorData +"'></em>" + _text + "</a></li>";
				}
				
			}else{
				sItem += "<li class='"+className+"'><a href='#'>" + _text + "</a></li>";
			}
		});

		$(".euiSelectList", this.visualElement).html(sItem);
		
		this._setTitle();
	};

	efusioni.ui.Select.prototype._setTitle = function() {
		var self = this;
		//console.log($(".euiSelectTitle", this.visualElement),children().remove())
		$(".euiSelectTitle", this.visualElement).text($("option:selected", this.formElement).text());
		if($('option:selected', this.formElement).parent().hasClass('selectColor')){
			$('option:selected', this.formElement).parent().parent().find('.euiSelectMain em').remove()
			if($('option:selected', this.formElement).index() == 0){
				$(".euiSelectTitle", this.visualElement).before("<em class='firstOption'></em>");
			}else{
				$(".euiSelectTitle", this.visualElement).before("<em style='background:#"+ $('option:selected', this.formElement).attr('data-color') +"'></em>");
			}	
		}
		
		
		$(".euiSelectList li", this.visualElement).each(function(){
			if($(this).hasClass('selected')){
				$(".eui_defaultSelect").addClass("selected");
			}
		});
		
		if (this.template.itemOnClass != null) {
			$(".euiSelectList li", this.visualElement).each(function(idx) {
				$(this).removeClass();
				if (idx == $("option:selected", self.formElement).index()) {
					$(this).attr("class", self.template.itemOnClass);
				}
				else {
					$(this).attr("class", "");
				}
			});
		}
		
		
		if (this.template.itemSelecClass != null) {
			$(".euiSelectList li", this.visualElement).each(function(idx) {
				$(this).removeClass();
				if (idx == $("option:selected", self.formElement).index()) {
					$(this).attr("class", self.template.itemSelecClass);
				}
				else {
					$(this).attr("class", "");
				}
			});
		}
		
		if ($(this.formElement).prop("disabled")) {
			$(".euiSelectMain", this.visualElement).addClass("disabled");
		}
		else {
			$(".euiSelectMain", this.visualElement).removeClass("disabled");
		}
	};

	efusioni.ui.Select.prototype._setBaseListener = function() {
		var self = this;

		/*mouseOver시 펼침을 선택했을 때*/
		if (this.template.isMouseOverFolding != null && this.template.isMouseOverFolding) {
			/*Select Box 기본 Folding */
			$(self.visualElement).mouseenter(function() {
				if (!$(self.formElement).prop("disabled")) {
					for (var i=0; i<efusioni.ui.UIManager.size(); i++) {
						var obj = efusioni.ui.UIManager.get(i);
			
						if (obj.type == "SELECT") {
							if (self.euiIdx == obj.euiIdx) {
								$(self.visualElement).css("z-index", efusioni.ui.UIManager.MAX_ZINDEX);
								$(".euiSelectList", self.visualElement).show();
								$(".euiSelectMain", self.visualElement).addClass("on");
							}
							else {
								/*자신외의 다른 SelectBox들은 클릭시 list item을 닫아줘야 한다.*/
								$(obj.visualElement).css("z-index", self.zIndex);
								$(".euiSelectList", obj.visualElement).hide();
								$(".euiSelectMain", obj.visualElement).removeClass("on");
								$(".euiSelectMain", obj.visualElement).parent().removeClass("on");
							}
						}
					}
				}
			});
			
			$(self.visualElement).mouseleave(function() {
				if (!$(self.formElement).prop("disabled")) {
					$(".euiSelectList", self.visualElement).hide();
					$(".euiSelectMain", self.visualElement).removeClass("on");
					$(".euiSelectMain", self.visualElement).parent().removeClass("on");
				}
			});
		}
	};
	
	efusioni.ui.Select.prototype._setTitleListener = function() {
		var self = this;
		/*Select Box 기본 Folding */
		if (this.template.isMouseOverFolding == null || !this.template.isMouseOverFolding) {
			/*Select Box 기본 Folding */
			$(".euiSelectMain", self.visualElement).off('click');
			$(".euiSelectMain", self.visualElement).on('click', function(e) {
				if (!$(self.formElement).prop("disabled")) {
					for (var i=0; i<efusioni.ui.UIManager.size(); i++) {
						var obj = efusioni.ui.UIManager.get(i);
						if (obj.type == "SELECT") {
							if (self.euiIdx == obj.euiIdx) {
								if(!$(".euiSelectMain", self.visualElement).hasClass('on')){
									$(self.visualElement).css("z-index", efusioni.ui.UIManager.MAX_ZINDEX);
									$(".euiSelectList", self.visualElement).show();
									if($(this).parent().hasClass('selected')){
										$(".euiSelectList", this.visualElement).scrollTop((selectIdx-3) * 34)
									}
									$(".euiSelectMain", self.visualElement).addClass("on");
									$(this).parent().addClass('on');
								}else{
									$(obj.visualElement).css("z-index", self.zIndex);
									$(".euiSelectList", obj.visualElement).hide();
									$(".euiSelectMain", obj.visualElement).removeClass("on");
									$(".euiSelectMain", obj.visualElement).parent().removeClass("on");
								}
							}
							else {
								/*자신외의 다른 SelectBox들은 클릭시 list item을 닫아줘야 한다.*/
								$(obj.visualElement).css("z-index", self.zIndex);
								$(".euiSelectList", obj.visualElement).hide();
								$(".euiSelectMain", obj.visualElement).removeClass("on");
								$(".euiSelectMain", obj.visualElement).parent().removeClass("on");
							}
						}
					}
				}
				e.preventDefault();
			});
		}
	};

	efusioni.ui.Select.prototype._setItemListener = function() {
		var self = this;
		/*Item을 클릭했을때, 원본 SelectBox의 이벤트를 Simulate*/
		$(".euiSelectList li a", self.visualElement).click(function(e) {
			if (!$(self.formElement).prop("disabled")) {
				/*onchange성격에 맞게 다른 Item을 클랙했을 경우만*/
				if (self.formElement.prop("selectedIndex") != $(this).parent().index()) {	
					self.formElement.prop("selectedIndex", $(this).parent().index());
					self._setTitle();	
					/*원본 SelectBox의 이벤트를 호출*/
					self.formElement.change();
					selectIdx = $(this).parent().index()
					//$(".euiSelectList", this.visualElement).scrollTop(($(this).parent().index()-3) * 34)
				}
				$(self.visualElement).css("z-index", self.zIndex);
				$(".euiSelectList", self.visualElement).hide();
				$(".euiSelectMain", self.visualElement).removeClass("on");
				$(".euiSelectMain", self.visualElement).parent().removeClass("on");
			}
			e.preventDefault();
		});
		
		/*itemOn Class를 지정했을시 마우스 over 효과*/
		if (this.template.itemOnClass != null) {
			if (!$(self.formElement).prop("disabled")) {
				$(".euiSelectList li a", this.visualElement).mouseenter(function() {
					$(this).parent().attr("class", self.template.itemOnClass);
				});
				
				$(".euiSelectList li a", this.visualElement).mouseleave(function() {
					if ($(this).parent().index() != $("option:selected", self.formElement).index()) {
						$(this).parent().attr("class", "");
					}
				});
			}
		}
	};
	//UI Select 선언 끝 --------------------------------------------------------
	
	
	//UI Radio 선언 시작 --------------------------------------------------------
	efusioni.ui.Radio = function (formElement) {
		this.formElement = $(formElement);
		this.className = this.formElement.attr("class");
		this.checkType = this.formElement.attr("checked");
	};

	efusioni.ui.Radio.prototype.render = function() {
		this.formElement.wrap('<span class="' + this.className + '_off"></span>');
		if(this.checkType){
			this.formElement.parent().addClass(this.className + "_on");
		}
		this.formElement.click(function(){
			$("input[name=" + $(this).attr("name") + "]").parent().removeClass(this.className + "_on");	
			$(this).parent().addClass(this.className + "_on");
		});
	};

	efusioni.ui.Radio.prototype.update = function() {
		$("input[name=" + this.formElement.attr("name") + "]").parent().removeClass(this.className + "_on");	
		this.formElement.parent().addClass(this.className + "_on");
	};
	
	//UI Radio 선언 끝 --------------------------------------------------------
	
	
	//UI Check 선언 시작 --------------------------------------------------------
	efusioni.ui.Check = function (formElement) {
		this.formElement = $(formElement);
		this.className = this.formElement.attr("class");
		this.checkType = this.formElement.attr("checked");
	};

	efusioni.ui.Check.prototype.render = function() {
		this.formElement.wrap('<span class="' + this.className + '_off"></span>');
		if(this.checkType){
			this.formElement.parent().addClass(this.className + "_on");
		}
		this.formElement.click(function(){
			$(this).parent().toggleClass(this.className + "_on");
		});
	};

	efusioni.ui.Check.prototype.update = function() {
		if(this.checkType){
			this.formElement.parent().addClass(this.className + "_on");	
		} else {
			this.formElement.parent().removeClass(this.className + "_on");
		}		
	};
	//UI Check 선언 끝 --------------------------------------------------------
	
	
	
	
	