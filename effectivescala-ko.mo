<a href="http://github.com/twitter/effectivescala"><img style="position: absolute; top: 0; left: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_left_green_007200.png" alt="깃허브에서 포크하세요"></a>

<h1 class="header">이펙티브 스칼라</h1>
<address>매리어스 에릭슨(Marius Eriksen), (주) 트위터<br />marius@twitter.com (<a href="http://twitter.com/marius">@marius</a>)</address>

<h2>목차</h2>

.TOC


<h2>다른 언어</h2>
<a href="index.html">English</a>
<a href="index-ja.html">日本語</a>
<a href="index-ru.html">Русский</a>
<a href="index-cn.html">简体中文</a>


## 소개

[Scala][Scala]는 트위터에서 사용하는 기본 애플리케이션 프로그래밍 언어 
중 하나다. 많은 트위터 하부구조가 스칼라로 작성되었으며 스칼라를 
사용하는데 도움이 되는 [여러 대규모 라이브러리](http://github.com/twitter/)도 
만들었다. 스칼라는 효율이 좋긴 하지만 방대한 언어고, 트위터에서 스칼라를 
사용한 경험이 늘면서 애플리케이션에 적용해야할 주의 사항이 있다는 
사실을 배웠다. 조심해야 할 위험은 뭐고, 수용하거나 피해야 할 특징은 뭔지, 
언제 "순수 함수형 방식"을 적용하고 언제 하지 말지... 다시 말해, 이 언어를 
효율적으로 사용하려 하면서 발견한 것들이다. 이 지침서에 트위터의 경험을 
정재해서 짧게 정리하고 *우수 실천법*을 제공하려 한다. 트위터에서는 스칼라를 
주로 분산 시스템을 구성하는 대용량 서비스를 만드는 데 사용하긴 하지만(그래서
우리의 조언이 어느 정도 편파적이니만), 여기에 적힌 조언 대부분은 다른 
영역에도 자연스럽게 적용될 것이다. 이 지침은 법이 아니다. 하지만, 어길 때에는
그럴만한 이유가 있어야 한다.

스칼라에는 간결하게 표현하도록 돕는 수단이 많다. 작성하는 양이 적으면 읽을
양도 줄어들며, 읽는 양이 적으면 대부분 읽는 속도도 빨리진다. 그리고 이런
간결함은 명료성을 개선한다. 하지만 간결함은 섬세하지 못한 수단이라서 역효과가
일어나기도 한다. 언제나 정확성 이면의 독자를 고려해야 한다.

무엇보다, *스칼라로 프로그래밍을 해야 한다*. 우리는 자바나 하스켈이나 
파이썬으로 코딩을 하는 게 아니다. 스칼라 프로그램은 이것들로 작성한 것과 
다르다. 이 언어를 효과적으로 사용하려면, 이 언어로 문제를 표현해야 한다. 
자바 프로그램에 스칼라 방식을 강요하는 건 소용없다. 모든 관점에서 원래보다 
떨어질 것이기 때문이다.

이 글은 스칼라를 소개하는 글이 아니다. 독자가 스칼라에 친숙하다고 
가정했다. 스칼라를 공부하려면 다음을 참고하자.

* [스칼라 학교(Scala School)](http://twitter.github.com/scala_school/)
* [스칼라 학습(Learning Scala)](http://www.scala-lang.org/node/1305)
* [스칼라 속성 학습(Learning Scala in Small Bites)](http://matt.might.net/articles/learning-scala-in-small-bites/)

이 문서는 완성본이 아니며 트위터의 최신 "우수 실천법"을 
반영하도록 변경될테지만, 핵심 사상은 바뀌지 않을 것 같다. 우리는 
언제나 가독성을 추구하고, 일반적인 코드를 작성하지만 명확도를 
높이려고 과도한 비용을 들이지 않으며, 단순한 언어의 장점을 취해서 
위력을 누리면서도 (특히 타입 시스템의) 난해한 면은 피한다. 
무엇보다, 내리는 결정의 득실에 언제나 주의한다. 정교한 언어는
구현이 복잡해지며, 복잡성은 추론과 의미와 기능간의 상호 작용과 협업 
대상자에 대한 이해 등을 복잡하게 만드는 또다른 복잡성을 낳는다.  이런 
복잡성은 정교함이 지불해야 할 세금이다(늘 비용보다 더 가치있게 사용해야 
한다.)

그러면 즐거운 시간 되기 바란다.

## 서식

코드 *서식*에 대한 (실용적인 관계로 매우 긴) 세부 항목이
중요하진 않다. (코드를) 정의하는 형식은 본질적으로 좋거나 
나쁘다고 할 수 없고 거의 모든 사람의 개인적인 취향이 다르기 
때문이다. 하지만 동일한 서식 규칙을 일관되게 
적용하면 대부분 가독성을 개선하는 효과가 있을 
것이다. 이미 특정 형식에 익숙한 사람은 
파일마다 다른 관례를 이해하거나 전혀 다른 문법을 
해독할 필요가 없다.

이는 스칼라에서 특히 중요한데, 스칼라는 문법이 매우
중복되기 때문이다. 예 하나를 들자면 메서드 호출이다. 메서드는
"`.`"로, 그리고 공백으로, 또 매개변수가 없거나 하나인 
메서드는 괄호도 생략하는 등 다양하게 호출할 수 있다. 
더욱이, 이렇게 다양한 메서드 호출 형식 때문에 문법도 
여러면에서 모호해진다. 확실히 세심하게 선정된 서식 
규칙을 일관되게 적용하면 사람과 기계 모두 모호한 문법을
다뤄야 하는 곤란한 상황에서 벗어나게 될 것이다.

트위터는 [스칼라 서식 
지침서](http://docs.scala-lang.org/style/)와 더불어 다음 규칙을 지킨다.

### 공백

공백 두 칸으로 들여쓴다. 가능한 한 줄이 100 자가 넘지 않도록 
한다. 메서드, 클래스, 객체 정의 사이에는 한 줄 띄운다.

### 작명

<dl class="rules">
<dt>작은 범위(scope)에는 짧은 이름을 사용</dt>
<dd> <code>i</code>, <code>j</code>, <code>k</code> 모두 가능지만
특히 반복에 사용된다.</dd>
<dt>범위(scope)가 크면 긴 이름을 사용</dt>
<dd>외부 API의 이름은 길고 의도를 설명해야 한다.</dd>
<code>Future.all</code>가 아닌 <code>Future.collect</code>.
</dd>
<dt>통용되는 약자만 사용하고 난해한 약자는 지양</dt>
<dd>
<code>ok</code>, <code>err</code>, <code>defn</code>은 
모두 알지만 <code>sfri</code>는 그다지 일반적이지
않다.
</dd>
<dt>이름을 다른 용도로 재사용하지 않음</dt>
<dd><code>val</code>을 사용하라.</dd>
<dt>예약된 이름을 중복 사용할 때 <code>`</code>를 쓰지 않음</dt>
<dd><code>`type</code>`보다는 <code>typ</code>이라고 한다.</dd>
<dt>부수 효과가 있는 동작은 능동태를 사용</dt>
<dd><code>user.setActive()</code> 대신 <code>user.activate()</code>라고 한다.</dd>
<dt>값을 반환하는 메서드는 서술적인 이름을 사용</dt>
<dd><code>src.defined</code> 대신 <code>src.isDefined</code>라고 한다.</dd>
<dt>값을 얻는 메서드에 <code>get</code> 접두사를 붙이지 않음</dt>
<dd>위 규칙과 같이, 이는 과잉 표현이다. <code>site.getCount</code> 대신 <code>site.count</code>라고 한다.</dd>
<dt>이미 패키지나 객체 이름으로 캡슐화된 이름은 반복하지 않음</dt>
<dd>
<pre><code>object User {
  def getUser(id: Int): Option[User]
}</code></pre> 라고 하기 보다는
<pre><code>object User {
  def get(id: Int): Option[User]
}</code></pre> 라고 한다. 사용할 때 장황해진다. <code>User.getUser</code>가
<code>User.get</code>보다 추가로 주는 정보는 없다.
</dd>
</dl>


### 임포트(Imports)

<dl class="rules">
<dt>임포트는 알파벳 순으로 정렬</dt>
<dd>시각적으로 확인하기 쉬워지며, 자동화하기 간단하다.</dd>
<dt>한 패키지에서 여러 이름을 임포트할 때에는 중괄호를 사용</dt>
<dd><code>import com.twitter.concurrent.{Broker, Offer}</code></dd>
<dt>이름을 여섯가지 이상 임포트할 때에는 와일드카드를 사용</dt>
<dd>예: <code>import com.twitter.concurrent._</code>
<br />무조건 사용하지는 말아라. 어떤 패키지에는 너무 많은 이름이 포함돼 있다.</dd>
<dt>집합체(collection)를 사용할 때에는, <code>scala.collection.immutable</code>와 <code>scala.collection.mutable</code>로 이름을 분명하게 규정</dt>
<dd>가변(Mutable) 집합체와 불변(immutable) 집합체는 같은 이름을 쓴다. 
이름을 정규화(Qualifiy)하면 코드를 읽는 사람이 어떤 유형인지 혼돈하지 않는다. (예 "<code>immutable.Map</code>")</dd>
<dt>다른 패키지에서 상대 임포트를 하지 않음</dt>
<dd><pre><code>import com.twitter
import concurrent</code></pre> 대신 명백하게 <pre><code>import com.twitter.concurrent</code></pre>라고 한다.</dd>
<dt>임포트는 파일 상단에 배치</dt>
<dd>코드를 읽는 사람이 한 곳에서 모든 임포트를 조회할 수 있다.</dd>
</dl>

### 중괄호

중괄호는 복합 식을 만드는 데 사용("모듈 언어"에서는 용도가 
다름) 되는데, 여러 식 중 마지막 식이 복합 식의 값은 된다. 
단순한 식에는 중괄호를 사용하지 않는다. 메서드 본문을 구문으로
구분하고 싶다고 해도

	def square(x: Int) = x*x
	
.LP 라고 쓰는 대신

	def square(x: Int) = {
	  x * x
	}
	
.LP 이라고 한다. 둘 중 먼저 것이 어수선하지 않고 읽기 쉽다. 이해하기 쉽게 만들지 않는 한 <em>구문 장식은 피하자</em>.

### 패턴 매칭

가능하다면 함수 정의에 패턴 매칭을 직접 사용한다.

	list map { item =>
	  item match {
	    case Some(x) => x
	    case None => default
	  }
	}
	
.LP 라고 하는 대신 match를 생략해서

	list map {
	  case Some(x) => x
	  case None => default
	}

.LP 라고 하자. 이 편이 리스트의 항목이 전부 사상된다는 점이 명확하다. 간접적으로 표현한다고 의미가 더 살지는 않는다.

### 주석

API 문서를 작성할 때에는 [ScalaDoc](https://wiki.scala-lang.org/display/SW/Scaladoc)을
사용한다. 다음과 같이하고

	/**
	 * ServiceBuilder는 서비스를 구축한다.
	 * ...
	 */
	 
.LP 표준 ScalaDoc 형식은 사용하지 <em>말자</em>.

	/** ServiceBuilder는 서비스를 구축한다.
	 * ...
	 */

아스키(ASCII) 그림이나 다른 시각적인 장치에 의존하지 않는다. 문서
API외의 불필요한 주석은 추가하지 않는다. 코드의 작동 방식이 모호해서
주석으로 설명해야 한다고 되면, 하는 일이 분명하게 드러나도록 
구조를 개선할 수 있는지 먼저 생각해보자. 그저 정확히 동작하기 보다
의도를 분명하게 드러내도록 한다. 호어(Hoare)에게는 미안하지만...

## 자료형(Type)과 지네릭(Generics)

자료형 체계(Type System)의 주 목적은 프로그래밍 오류를 탐지하는 
것이다. 자료형 체계는 효과적으로 정적 검증이라는 제한된 
틀을 제공하는데, 코드에 일종의 불변식을 표현해서 컴파일러가 
검증하도록 할 수 있다. 물론 자료형 체계에는 다른 이점도 있지만, 
오류 확인이야 말로 타입 시스템의 레종 데트르(Raison d&#146;&Ecirc;tre), 존재의 이유이다.

자료형 체계는 이 목적을 반영해서 사용해야 하며, 독자도 
여전해 생각해야 한다. 자료형을 현명하게 사용하면 더 명료하게 
만들 수 있다. 지나치게 영리하면 혼돈만 일어난다.

스칼라의 강력한 자료형 체계는 학문적으로 탐구와 실습의 일반적인 
대상이다(예: [스칼라로 하는 자료형 수준 프로그래밍(Type level programming in Scala)](http://apocalisp.wordpress.com/2010/06/08/type-level-programming-in-scala/)).
이런 기술은 학문적 주제로는 멋질지 몰라도, 상용 코드에 유용하게 
적용되는 일이 드물다. 이런 것은 피해야 한다.

### 반환 자료형 지정

스칼라는 반환 자료형을 생략할 수 있지만, 명기하면 좋은 문서가 
된다. 이는 특히 공용 메서드(public method)에 중요하다. 외부에
노출되지 않는 메서드라면 명백하게 반환 자료형은 생략한다. 

이는 특히 믹스인을 한 객체를 생성할 때 중요한데 스칼라 컴파일러가 
싱글턴 자료형을 생성하기 때문이다. 예를 들어, 다음 코드의 `make`는
<code>Service</code>인 반환 자료형이 <em>없다</em>.

	trait Service
	def make() = new Service {
	  def getId = 123
	}

.LP 컴파일러는 정제된 자료형인 <code>Object with Service{def getId: Int}</code>를 
생성한다. 대신 명시적으로 자료형을 지정한다.

	def make(): Service = new Service{}

이렇게 하면 작성자가 `make`의 공개 자료형을 바꾸지 않고 자유롭게
다른 트레잇(trait)을 믹시인할 수 있어 하위 호환성을 유지하기 
쉬워진다.

### 자료형 변위(變位; Variance)

자료형 변위는 지네릭과 자료형 파생(subtyping)이 결합할 때 일어난다. 자료형
가변성은 내포된 자료형의 자료형 파생과 수용하는 자료형의 자료형 
파생의 관계를 정의한다. 스칼라는 가변성 표시를 선언하는 장소가 
있어서, 공용 라이브러리(특히 집합체)의 저자는 
이런 표기는 공유되는 코드의 사용성에 중요하지만 잘못 적용하면 위험하다.

자료형 불변성은 고급 주제이지만 스칼라의 자료형 체계에서 필요한 측면이며,
자료형 파생의 적용에 도움이 되므로 널리 (올바르게) 사용되어야 할 
것이다.

값을 수정할 수 없는 *고정 집합체(immutable collection)는 공변(covariant)이어야 한다*.
내포된 자료형을 전달 받는 메서드는 적절하게 집합체의 자료형을 상위로 높여야 한다.

	trait Collection[+T] {
	  def add[U >: T](other: U): Collection[U]
	}

내용을 수정할 수 있는 *유동 집합체(Mutable collections)는 불변(invariant)이어야 한다*.
공변은 보통 유동값 집합체에서 유효하지 않다. 다음과 같은 집합체가 있고

	trait HashSet[+T] {
	  def add[U >: T](item: U)
	}

.LP 다음의 자료형 상속 계층이 있을 때

	trait Mammal
	trait Dog extends Mammal
	trait Cat extends Mammal

.LP Dog의 HashSet이 있는데

	val dogs: HashSet[Dog]

.LP 이를 Mammal의 HashSet으로 취급하고 Cat을 추가했다면

	val mammals: HashSet[Mammal] = dogs
	mammals.add(new Cat{})

.LP 더이상 Dog의 HashSet이 아니다.

<!--
  *	when to use abstract type members?
  *	show contravariance trick?
-->

### 자료형 별칭

Use type aliases when they provide convenient naming or clarify
purpose, but do not alias types that are self-explanatory.

자료형 별칭으로 작명이 편리해지거나 의도가 분명해진다면 
사용하지만, 따로 설명이 필요하지 않은 자료형은 별칭을 만들지 않는다.

	() => Int

.LP is clearer than
.LP 는

	type IntMaker = () => Int
	IntMaker

.LP 보다 분명하다. 원 자료형과 별칭 모두 간략하고 일반적인 자료형이기 때문이다. 하지만,

	class ConcurrentPool[K, V] {
	  type Queue = ConcurrentLinkedQueue[V]
	  type Map   = ConcurrentHashMap[K, Queue]
	  ...
	}

.LP 는 의도를 나타내고 더 간결하기 때문에 도움이 된다.

별칭으로 대신할 수 있을 때는 상속을 쓰지 않는다.

	trait SocketFactory extends (SocketAddress => Socket)
	
.LP <code>SocketFactory</code>는 <code>Socket</code>을 생성하는 
함수다. 자료형 별칭을 사용하는 편이 낫다.

	type SocketFactory = SocketAddress => Socket

.LP <code>SocketFactory</code> 자료형의 값에 함수 리터럴을 사용할 수 있으며 함수 조합도 할 수 있다.

	val addrToInet: SocketAddress => Long
	val inetToSocket: Long => Socket

	val factory: SocketFactory = addrToInet andThen inetToSocket

패키지 객체를 사용하면 자료형 별칭은 최상위 명칭에 결합된다.

	package com.twitter
	package object net {
	  type SocketFactory = (SocketAddress) => Socket
	}

자료형 별칭은 새로운 타입이 아님에 주의하자. 자료형 별칭은 
이름을 자료형과 구문적으로 치환하는 것과 동일하다.

### 암시(Implicits)

암시는 강력한 형 체계 기능이지만, 아주 가끔만 사용해야 
한다. 처리하는 규칙이 복잡해서 (단순한 어휘 검사라도) 
실제로 어떤 일이 일어나는지 이해하기 
힘들다.  다음과 같은 상황이라면 분명히 암시를 사용해도
좋다.

* 스칼라 방식의 집합체를 확장하거나 추가함
* 객체를 도입하거나 확장함 ("[라이브러리 중매][pimp my library]" pattern)
* [제약 증거][generalized type constraints]를 사용해 형 안전성을 강화하는 데 사용
* [형 증거][type evidence]를 제공함
* [Manifest][Manifest] 용

암시를 사용할 때면 언제나 암시 없이 동일한 결과를 얻을 방법이 없나
찾아본다.

비슷한 자료형으로 자동 변환하려고 암시를 사용하지 말자[예를들어, 
스트림(Stream)을 리스트(List)로 변환한다거나]. 두 형이 다르게 동작해서
코드를 읽는 사람이 암시적 방법이 사용되었는지 주의해야 하므로
명시적 변환이 낫다.

## 집합체(Collections)

Scala has a very generic, rich, powerful, and composable collections
library; collections are high level and expose a large set of
operations. Many collection manipulations and transformations can be
expressed succinctly and readably, but careless application of its
features can often lead to the opposite result. Every Scala programmer
should read the [collections design
document](http://www.scala-lang.org/docu/files/collections-api/collections.html);
it provides great insight and motivation for Scala collections
library.

Always use the simplest collection that meets your needs.

### Hierarchy

The collections library is large: in addition to an elaborate
hierarchy -- the root of which being `Traversable[T]` -- there are
`immutable` and `mutable` variants for most collections. Whatever
the complexity, the following diagram contains the important 
distinctions for both `immutable` and `mutable` hierarchies

<img src="coll.png" style="margin-left: 3em;" />
.cmd
pic2graph -format png >coll.png <<EOF 
boxwid=1.0

.ft I
.ps +9

Iterable: [
	Box: box wid 1.5*boxwid
	"\s+2Iterable[T]\s-2" at Box
]

Seq: box "Seq[T]" with .n at Iterable.s + (-1.5, -0.5)
Set: box "Set[T]" with .n at Iterable.s + (0, -0.5)
Map: box "Map[T]" with .n at Iterable.s + (1.5, -0.5)

arrow from Iterable.s to Seq.ne
arrow from Iterable.s to Set.n
arrow from Iterable.s to Map.nw
EOF
.endcmd

.LP <code>Iterable[T]</code> is any collection that may be iterated over, they provide an <code>iterator</code> method (and thus <code>foreach</code>). <code>Seq[T]</code>s are collections that are <em>ordered</em>, <code>Set[T]</code>s are mathematical sets (unordered collections of unique items), and <code>Map[T]</code>s are associative arrays, also unordered.

### Use

*Prefer using immutable collections.* They are applicable in most
circumstances, and make programs easier to reason about since they are
referentially transparent and are thus also threadsafe by default.

*Use the `mutable` namespace explicitly.* Don't import
`scala.collection.mutable._` and refer to `Set`, instead

	import scala.collection.mutable
	val set = mutable.Set()

.LP makes it clear that the mutable variant is being used.

*Use the default constructor for the collection type.* Whenever you
need an ordered sequence (and not necessarily linked list semantics),
use the `Seq()` constructor, and so on:

	val seq = Seq(1, 2, 3)
	val set = Set(1, 2, 3)
	val map = Map(1 -> "one", 2 -> "two", 3 -> "three")

.LP This style separates the semantics of the collection from its implementation, letting the collections library uses the most appropriate type: you need a <code>Map</code>, not necessarily a Red-Black Tree. Furthermore, these default constructors will often use specialized representations: for example, <code>Map()</code> will use a 3-field object for maps with 3 keys.

The corrolary to the above is: in your own methods and constructors, *receive the most generic collection
type appropriate*. This typically boils down to one of the above:
`Iterable`, `Seq`, `Set`, or `Map`. If your method needs a sequence,
use `Seq[T]`, not `List[T]`.

<!--
something about buffers for construction?
anything about streams?
-->

### Style

Functional programming encourages pipelining transformations of an
immutable collection to shape it to its desired result. This often
leads to very succinct solutions, but can also be confusing to the
reader -- it is often difficult to discern the author's intent, or keep
track of all the intermediate results that are only implied. For example,
let's say we wanted to aggregate votes for different programming 
languages from a sequence of (language, num votes), showing them
in order of most votes to least, we could write:
	
	val votes = Seq(("scala", 1), ("java", 4), ("scala", 10), ("scala", 1), ("python", 10))
	val orderedVotes = votes
	  .groupBy(_._1)
	  .map { case (which, counts) => 
	    (which, counts.foldLeft(0)(_ + _._2))
	  }.toSeq
	  .sortBy(_._2)
	  .reverse

.LP this is both succinct and correct, but nearly every reader will have a difficult time recovering the original intent of the author. A strategy that often serves to clarify is to <em>name intermediate results and parameters</em>:

	val votesByLang = votes groupBy { case (lang, _) => lang }
	val sumByLang = votesByLang map { case (lang, counts) =>
	  val countsOnly = counts map { case (_, count) => count }
	  (lang, countsOnly.sum)
	}
	val orderedVotes = sumByLang.toSeq
	  .sortBy { case (_, count) => count }
	  .reverse

.LP the code is nearly as succinct, but much more clearly expresses both the transformations take place (by naming intermediate values), and the structure of the data being operated on (by naming parameters). If you worry about namespace pollution with this style, group expressions with <code>{}</code>:

	val orderedVotes = {
	  val votesByLang = ...
	  ...
	}


### Performance

High level collections libraries (as with higher level constructs
generally) make reasoning about performance more difficult: the
further you stray from instructing the computer directly -- in other
words, imperative style -- the harder it is to predict the exact
performance implications of a piece of code. Reasoning about
correctness however, is typically easier; readability is also
enhanced. With Scala the picture is further complicated by the Java
runtime; Scala hides boxing/unboxing operations from you, which can
incur severe performance or space penalties.

Before focusing on low level details, make sure you are using a
collection appropriate for your use. Make sure your datastructure
doesn't have unexpected asymptotic complexity. The complexities of the
various Scala collections are described
[here](http://www.scala-lang.org/docu/files/collections-api/collections_40.html).

The first rule of optimizing for performance is to understand *why*
your application is slow. Do not operate without data;
profile^[[Yourkit](http://yourkit.com) is a good profiler] your
application before proceeding. Focus first on hot loops and large data
structures. Excessive focus on optimization is typically wasted
effort. Remember Knuth's maxim: "Premature optimisation is the root of
all evil."

It is often appropriate to use lower level collections in situations
that require better performance or space efficiency. Use arrays
instead of lists for large sequences (the immutable `Vector`
collections provides a referentially transparent interface to arrays);
and use buffers instead of direct sequence construction when
performance matters.

### Java Collections

Use `scala.collection.JavaConverters` to interoperate with Java collections.
These are a set of implicits that add conversion `asJava` and `asScala` conversion
methods. The use of these ensures that such conversions are explicit, aiding
the reader:

	import scala.collection.JavaConverters._
	
	val list: java.util.List[Int] = Seq(1,2,3,4).asJava
	val buffer: scala.collection.mutable.Buffer[Int] = list.asScala

## Concurrency

Modern services are highly concurrent -- it is common for servers to
coordinate 10s-100s of thousands of simultaneous operations -- and
handling the implied complexity is a central theme in authoring robust
systems software.

*Threads* provide a means of expressing concurrency: they give you
independent, heap-sharing execution contexts that are scheduled by the
operating system. However, thread creation is expensive in Java and is
a resource that must be managed, typically with the use of pools. This
creates additional complexity for the programmer, and also a high
degree of coupling: it's difficult to divorce application logic from
their use of the underlying resources.

This complexity is especially apparent when creating services that
have a high degree of fan-out: each incoming request results in a
multitude of requests to yet another tier of systems. In these
systems, thread pools must be managed so that they are balanced
according to the ratios of requests in each tier: mismanagement of one
thread pool bleeds into another. 

Robust systems must also consider timeouts and cancellation, both of
which require the introduction of yet more "control" threads,
complicating the problem further. Note that if threads were cheap
these problems would be diminished: no pooling would be required,
timed out threads could be discarded, and no additional resource
management would be required.

Thus resource management compromises modularity.

### Futures

Use Futures to manage concurrency. They decouple
concurrent operations from resource management: for example, [Finagle][Finagle]
multiplexes concurrent operations onto few threads in an efficient
manner. Scala has lightweight closure literal syntax, so Futures
introduce little syntactic overhead, and they become second nature to
most programmers.

Futures allow the programmer to express concurrent computation in a
declarative style, are composable, and have principled handling of
failure. These qualities has convinced us that they are especially
well suited for use in functional programming languages, where this is
the encouraged style.

*Prefer transforming futures over creating your own.* Future
transformations ensure that failures are propagated, that
cancellations are signalled, and frees the programmer from thinking
about the implications of the Java memory model. Even a careful
programmer might write the following to issue an RPC 10 times in
sequence and then print the results:

	val p = new Promise[List[Result]]
	var results: List[Result] = Nil
	def collect() {
	  doRpc() onSuccess { result =>
	    results = result :: results
	    if (results.length < 10)
	      collect()
	    else
	      p.setValue(results)
	  } onFailure { t =>
	    p.setException(t)
	  }
	}

	collect()
	p onSuccess { results =>
	  printf("Got results %s\n", results.mkString(", "))
	}

The programmer had to ensure that RPC failures are propagated,
interspersing the code with control flow; worse, the code is wrong!
Without declaring `results` volatile, we cannot ensure that `results`
holds the previous value in each iteration. The Java memory model is a
subtle beast, but luckily we can avoid all of these pitfalls by using
the declarative style:

	def collect(results: List[Result] = Nil): Future[List[Result]] =
	  doRpc() flatMap { result =>
	    if (results.length < 9)
	      collect(result :: results)
	    else
	      result :: results
	  }

	collect() onSuccess { results =>
	  printf("Got results %s\n", results.mkString(", "))
	}

We use `flatMap` to sequence operations and prepend the result onto
the list as we proceed. This is a common functional programming idiom
translated to Futures. This is correct, requires less boilerplate, is
less error prone, and also reads better.

*Use the Future combinators*. `Future.select`, `Future.join`, and
`Future.collect` codify common patterns when operating over
multiple futures that should be combined.

### Collections

The subject of concurrent collections is fraught with opinions,
subtleties, dogma and FUD. In most practical situations they are a
nonissue: Always start with the simplest, most boring, and most
standard collection that serves the purpose. Don't reach for a
concurrent collection before you *know* that a synchronized one won't
do: the JVM has sophisticated machinery to make synchronization cheap,
so their efficacy may surprise you.

If an immutable collection will do, use it -- they are referentially
transparent, so reasoning about them in a concurrent context is
simple. Mutations in immutable collections are typically handled by
updating a reference to the current value (in a `var` cell or an
`AtomicReference`). Care must be taken to apply these correctly:
atomics must be retried, and `vars` must be declared volatile in order
for them to be published to other threads.

Mutable concurrent collections have complicated semantics, and make
use of subtler aspects of the Java memory model, so make sure you
understand the implications -- especially with respect to publishing
updates -- before you use them. Synchronized collections also compose
better: operations like `getOrElseUpdate` cannot be implemented
correctly by concurrent collections, and creating composite
collections is especially error prone.

<!--

use the stupid collections first, get fancy only when justified.

serialized? synchronized?

blah blah.

Async*?

-->


## Control structures

Programs in the functional style tends to require fewer traditional
control structure, and read better when written in the declarative
style. This typically implies breaking your logic up into several
small methods or functions, and gluing them together with `match`
expressions. Functional programs also tend to be more
expression-oriented: branches of conditionals compute values of
the same type, `for (..) yield` computes comprehensions, and recursion
is commonplace.

### Recursion

*Phrasing your problem in recursive terms often simplifies it,* and if
the tail call optimization applies (which can be checked by the `@tailrec`
annotation), the compiler will even translate your code into a regular loop.

Consider a fairly standard imperative version of heap <span
class="algo">fix-down</span>:

	def fixDown(heap: Array[T], m: Int, n: Int): Unit = {
	  var k: Int = m
	  while (n >= 2*k) {
	    var j = 2*k
	    if (j < n && heap(j) < heap(j + 1))
	      j += 1
	    if (heap(k) >= heap(j))
	      return
	    else {
	      swap(heap, k, j)
	      k = j
	    }
	  }
	}

Every time the while loop is entered, we're working with state dirtied
by the previous iteration. The value of each variable is a function of
which branches were taken, and it returns in the middle of the loop
when the correct position was found (The keen reader will find similar
arguments in Dijkstra's ["Go To Statement Considered Harmful"](http://www.u.arizona.edu/~rubinson/copyright_violations/Go_To_Considered_Harmful.html)).

Consider a (tail) recursive
implementation^[From [Finagle's heap
balancer](https://github.com/twitter/finagle/blob/master/finagle-core/src/main/scala/com/twitter/finagle/loadbalancer/Heap.scala#L41)]:

	@tailrec
	final def fixDown(heap: Array[T], i: Int, j: Int) {
	  if (j < i*2) return
	
	  val m = if (j == i*2 || heap(2*i) < heap(2*i+1)) 2*i else 2*i + 1
	  if (heap(m) < heap(i)) {
	    swap(heap, i, m)
	    fixDown(heap, m, j)
	  }
	}

.LP here every iteration starts with a well-defined <em>clean slate</em>, and there are no reference cells: invariants abound. It&rsquo;s much easier to reason about, and easier to read as well. There is also no performance penalty: since the method is tail-recursive, the compiler translates this into a standard imperative loop.

<!--
elaborate..
-->


### Returns

This is not to say that imperative structures are not also valuable.
In many cases they are well suited to terminate computation early
instead of having conditional branches for every possible point of
termination: indeed in the above `fixDown`, a `return` is used to
terminate early if we're at the end of the heap.

Returns can be used to cut down on branching and establish invariants.
This helps the reader by reducing nesting (how did I get here?) and
making it easier to reason about the correctness of subsequent code
(the array cannot be accessed out of bounds after this point). This is
especially useful in "guard" clauses:

	def compare(a: AnyRef, b: AnyRef): Int = {
	  if (a eq b)
	    return 0
	
	  val d = System.identityHashCode(a) compare System.identityHashCode(b)
	  if (d != 0)
	    return d
	    
	  // slow path..
	}

Use `return`s to clarify and enhance readability, but not as you would
in an imperative language; avoid using them to return the results of a
computation. Instead of

	def suffix(i: Int) = {
	  if      (i == 1) return "st"
	  else if (i == 2) return "nd"
	  else if (i == 3) return "rd"
	  else             return "th"
	}

.LP prefer:

	def suffix(i: Int) =
	  if      (i == 1) "st"
	  else if (i == 2) "nd"
	  else if (i == 3) "rd"
	  else             "th"

.LP but using a <code>match</code> expression is superior to either:

	def suffix(i: Int) = i match {
	  case 1 => "st"
	  case 2 => "nd"
	  case 3 => "rd"
	  case _ => "th"
	}

Note that returns can have hidden costs: when used inside of a closure,

	seq foreach { elem =>
	  if (elem.isLast)
	    return
	  
	  // process...
	}
	
.LP this is implemented in bytecode as an exception catching/throwing pair which, used in hot code, has performance implications.

### `for` loops and comprehensions

`for` provides both succinct and natural expression for looping and
aggregation. It is especially useful when flattening many sequences.
The syntax of `for` belies the underlying mechanism as it allocates
and dispatches closures. This can lead to both unexpected costs and
semantics; for example

	for (item <- container) {
	  if (item != 2) return
	}

.LP may cause a runtime error if the container delays computation, making the <code>return</code> nonlocal!

For these reasons, it is often preferrable to call `foreach`,
`flatMap`, `map`, and `filter` directly -- but do use `for`s when they
clarify.

### `require` and `assert`

`require` and `assert` both serve as executable documentation. Both are
useful for situations in which the type system cannot express the required
invariants. `assert` is used for *invariants* that the code assumes (either
internal or external), for example

	val stream = getClass.getResourceAsStream("someclassdata")
	assert(stream != null)

Whereas `require` is used to express API contracts:

	def fib(n: Int) = {
	  require(n > 0)
	  ...
	}

## Functional programming

*Value oriented* programming confers many advantages, especially when
used in conjunction with functional programming constructs. This style
emphasizes the transformation of values over stateful mutation,
yielding code that is referentially transparent, providing stronger
invariants and thus also easier to reason about. Case classes, pattern
matching, destructuring bindings, type inference, and lightweight
closure- and method-creation syntax are the tools of this trade.

### Case classes as algebraic data types

Case classes encode ADTs: they are useful for modelling a large number
of data structures and provide for succinct code with strong
invariants, especially when used in conjunction with pattern matching.
The pattern matcher implements exhaustivity analysis providing even
stronger static guarantees.

Use the following pattern when encoding ADTs with case classes:

	sealed trait Tree[T]
	case class Node[T](left: Tree[T], right: Tree[T]) extends Tree[T]
	case class Leaf[T](value: T) extends Tree[T]
	
.LP the type <code>Tree[T]</code> has two constructors: <code>Node</code> and <code>Leaf</code>. Declaring the type <code>sealed</code> allows the compiler to do exhaustivity analysis since constructors cannot be added outside the source file.

Together with pattern matching, such modelling results in code that is
both succinct and "obviously correct":

	def findMin[T <: Ordered[T]](tree: Tree[T]) = tree match {
	  case Node(left, right) => Seq(findMin(left), findMin(right)).min
	  case Leaf(value) => value
	}

While recursive structures like trees constitute classic applications of
ADTs, their domain of usefulness is much larger. Disjoint unions in particular are
readily modelled with ADTs; these occur frequently in state machines.

### Options

The `Option` type is a container that is either empty (`None`) or full
(`Some(value)`). They provide a safe alternative to the use of `null`,
and should be used in their stead whenever possible. They are a 
collection (of at most one item) and they are embellished with 
collection operations -- use them!

Write

	var username: Option[String] = None
	...
	username = Some("foobar")
	
.LP instead of

	var username: String = null
	...
	username = "foobar"
	
.LP since the former is safer: the <code>Option</code> type statically enforces that <code>username</code> must be checked for emptyness.

Conditional execution on an `Option` value should be done with
`foreach`; instead of

	if (opt.isDefined)
	  operate(opt.get)

.LP write

	opt foreach { value =>
	  operate(value)
	}

The style may seem odd, but provides greater safety (we don't call the
exceptional `get`) and brevity. If both branches are taken, use
pattern matching:

	opt match {
	  case Some(value) => operate(value)
	  case None => defaultAction()
	}

.LP but if all that's missing is a default value, use <code>getOrElse</code>

	operate(opt getOrElse defaultValue)
	
Do not overuse  `Option`: if there is a sensible
default -- a [*Null Object*](http://en.wikipedia.org/wiki/Null_Object_pattern) -- use that instead.

`Option` also comes with a handy constructor for wrapping nullable values:

	Option(getClass.getResourceAsStream("foo"))
	
.LP is an <code>Option[InputStream]</code> that assumes a value of <code>None</code> should <code>getResourceAsStream</code> return <code>null</code>.

### Pattern matching

Pattern matches (`x match { ...`) are pervasive in well written Scala
code: they conflate conditional execution, destructuring, and casting
into one construct. Used well they enhance both clarity and safety.

Use pattern matching to implement type switches:

	obj match {
	  case str: String => ...
	  case addr: SocketAddress => ...

Pattern matching works best when also combined with destructuring (for
example if you are matching case classes); instead of

	animal match {
	  case dog: Dog => "dog (%s)".format(dog.breed)
	  case _ => animal.species
	  }

.LP write

	animal match {
	  case Dog(breed) => "dog (%s)".format(breed)
	  case other => other.species
	}

Write [custom extractors](http://www.scala-lang.org/node/112) but only with
a dual constructor (`apply`), otherwise their use may be out of place.

Don't use pattern matching for conditional execution when defaults
make more sense. The collections libraries usually provide methods
that return `Option`s; avoid

	val x = list match {
	  case head :: _ => head
	  case Nil => default
	}

.LP because

	val x = list.headOption getOrElse default

.LP is both shorter and communicates purpose.

### Partial functions

Scala provides syntactical shorthand for defining a `PartialFunction`:

	val pf: PartialFunction[Int, String] = {
	  case i if i%2 == 0 => "even"
	}
	
.LP and they may be composed with <code>orElse</code>

	val tf: (Int => String) = pf orElse { case _ => "odd"}
	
	tf(1) == "odd"
	tf(2) == "even"

Partial functions arise in many situations and are effectively
encoded with `PartialFunction`, for example as arguments to
methods

	trait Publisher[T] {
	  def subscribe(f: PartialFunction[T, Unit])
	}

	val publisher: Publisher[Int] = ..
	publisher.subscribe {
	  case i if isPrime(i) => println("found prime", i)
	  case i if i%2 == 0 => count += 2
	  /* ignore the rest */
	}

.LP or in situations that might otherwise call for returning an <code>Option</code>:

	// Attempt to classify the the throwable for logging.
	type Classifier = Throwable => Option[java.util.logging.Level]

.LP might be better expressed with a <code>PartialFunction</code>

	type Classifier = PartialFunction[Throwable, java.util.Logging.Level]
	
.LP as it affords greater composability:

	val classifier1: Classifier
	val classifier2: Classifier

	val classifier = classifier1 orElse classifier2 orElse { _ => java.util.Logging.Level.FINEST }


### Destructuring bindings

Destructuring value bindings are related to pattern matching; they use the same
mechanism but are applicable when there is exactly one option (lest you accept
the possibility of an exception). Destructuring binds are particularly useful for
tuples and case classes.

	val tuple = ('a', 1)
	val (char, digit) = tuple
	
	val tweet = Tweet("just tweeting", Time.now)
	val Tweet(text, timestamp) = tweet

### Lazyness

Fields in scala are computed *by need* when `val` is prefixed with
`lazy`. Because fields and methods are equivalent in Scala (lest the fields
are `private[this]`)

	lazy val field = computation()

.LP is (roughly) short-hand for

	var _theField = None
	def field = if (_theField.isDefined) _theField.get else {
	  _theField = Some(computation())
	  _theField.get
	}

.LP i.e., it computes a results and memoizes it. Use lazy fields for this purpose, but avoid using lazyness when lazyness is required by semantics. In these cases it's better to be explicit since it makes the cost model explicit, and side effects can be controlled more precisely.

Lazy fields are thread safe.

### Call by name

Method parameters may be specified by-name, meaning the parameter is
bound not to a value but to a *computation* that may be repeated. This
feature must be applied with care; a caller expecting by-value
semantics will be surprised. The motivation for this feature is to
construct syntactically natural DSLs -- new control constructs in
particular can be made to look much like native language features.

Only use call-by-name for such control constructs, where it is obvious
to the caller that what is being passed in is a "block" rather than
the result of an unsuspecting computation. Only use call-by-name arguments
in the last position of the last argument list. When using call-by-name,
ensure that method is named so that it is obvious to the caller that 
its argument is call-by-name.

When you do want a value to be computed multiple times, and especially
when this computation is side effecting, use explicit functions:

	class SSLConnector(mkEngine: () => SSLEngine)
	
.LP The intent remains obvious and caller is left without surprises.

### `flatMap`

`flatMap` -- the combination of `map` with `flatten` -- deserves special
attention, for it has subtle power and great utility. Like its brethren `map`, it is frequently
available in nontraditional collections such as `Future` and `Option`. Its behavior
is revealed by its signature; for some `Container[A]`

	flatMap[B](f: A => Container[B]): Container[B]

.LP <code>flatMap</code> invokes the function <code>f</code> for the element(s) of the collection producing a <em>new</em> collection, (all of) which are flattened into its result. For example, to get all permutations of two character strings that aren't the same character repeated twice:

	val chars = 'a' to 'z'
	val perms = chars flatMap { a => 
	  chars flatMap { b => 
	    if (a != b) Seq("%c%c".format(a, b)) 
	    else Seq() 
	  }
	}

.LP which is equivalent to the more concise for-comprehension (which is &mdash; roughly &mdash; syntactical sugar for the above):

	val perms = for {
	  a <- chars
	  b <- chars
	  if a != b
	} yield "%c%c".format(a, b)

`flatMap` is frequently useful when dealing with `Options` -- it will
collapse chains of options down to one,

	val host: Option[String] = ..
	val port: Option[Int] = ..
	
	val addr: Option[InetSocketAddress] =
	  host flatMap { h =>
	    port map { p =>
	      new InetSocketAddress(h, p)
	    }
	  }

.LP which is also made more succinct with <code>for</code>

	val addr: Option[InetSocketAddress] = for {
	  h <- host
	  p <- port
	} yield new InetSocketAddress(h, p)

The use of `flatMap` in `Future`s is discussed in the 
<a href="#Twitter's%20standard%20libraries-Futures">futures section</a>.

## Object oriented programming

Much of Scala's vastness lies in its object system. Scala is a *pure*
language in the sense that *all values* are objects; there is no
distinction between primitive types and composite ones.
Scala also features mixins allowing for more orthogonal and piecemeal
construction of modules that can be flexibly put together at compile
time with all the benefits of static type checking.

A motivation behind the mixin system was to obviate the need for 
traditional dependency injection. The culmination of this "component
style" of programming is [the cake
pattern](http://jonasboner.com/2008/10/06/real-world-scala-dependency-injection-di/).

### Dependency injection

In our use, however, we've found that Scala itself removes so much of
the syntactical overhead of "classic" (constructor) dependency
injection that we'd rather just use that: it is clearer, the
dependencies are still encoded in the (constructor) type, and class
construction is so syntactically trivial that it becomes a breeze.
It's boring and simple and it works. *Use dependency injection for
program modularization*, and in particular, *prefer composition over
inheritance* -- for this leads to more modular and testable programs.
When encountering a situation requiring inheritance, ask yourself: how
would you structure the program if the language lacked support for
inheritance? The answer may be compelling.

Dependency injection typically makes use of traits,

	trait TweetStream {
	  def subscribe(f: Tweet => Unit)
	}
	class HosebirdStream extends TweetStream ...
	class FileStream extends TweetStream ..
	
	class TweetCounter(stream: TweetStream) {
	  stream.subscribe { tweet => count += 1 }
	}

It is common to inject *factories* -- objects that produce other
objects. In these cases, favor the use of simple functions over specialized
factory types.

	class FilteredTweetCounter(mkStream: Filter => TweetStream) {
	  mkStream(PublicTweets).subscribe { tweet => publicCount += 1 }
	  mkStream(DMs).subscribe { tweet => dmCount += 1 }
	}

### Traits

Dependency injection does not at all preclude the use of common *interfaces*, or
the implementation of common code in traits. Quite contrary-- the use of traits are
highly encouraged for exactly this reason: multiple interfaces
(traits) may be implemented by a concrete class, and common code can
be reused across all such classes.

Keep traits short and orthogonal: don't lump separable functionality
into a trait, think of the smallest related ideas that fit together. For example,
imagine you have an something that can do IO:

	trait IOer {
	  def write(bytes: Array[Byte])
	  def read(n: Int): Array[Byte]
	}
	
.LP separate the two behaviors:

	trait Reader {
	  def read(n: Int): Array[Byte]
	}
	trait Writer {
	  def write(bytes: Array[Byte])
	}
	
.LP and mix them together to form what was an <code>IOer</code>: <code>new Reader with Writer</code>&hellip; Interface minimalism leads to greater orthogonality and cleaner modularization.

### Visibility

Scala has very expressive visibility modifiers. It's important to use
these as they define what constitutes the *public API*. Public APIs
should be limited so users don't inadvertently rely on implementation
details and limit the author's ability to change them: They are crucial
to good modularity. As a rule, it's much easier to expand public APIs
than to contract them. Poor annotations can also compromise backwards
binary compatibility of your code.

#### `private[this]`

A class member marked `private`, 

	private val x: Int = ...
	
.LP is visible to all <em>instances</em> of that class (but not their subclasses). In most cases, you want <code>private[this]</code>.

	private[this] val: Int = ..

.LP which limits visibility to the particular instance. The Scala compiler is also able to translate <code>private[this]</code> into a simple field access (since access is limited to the statically defined class) which can sometimes aid performance optimizations.

#### Singleton class types

It's common in Scala to create singleton class types, for example

	def foo() = new Foo with Bar with Baz {
	  ...
	}

.LP In these situations, visibility can be constrained by declaring the returned type:

	def foo(): Foo with Bar = new Foo with Bar with Baz {
	  ...
	}

.LP where callers of <code>foo()</code> will see a restricted view (<code>Foo with Bar</code>) of the returned instance.

### Structural typing

Do not use structural types in normal use. They are a convenient and
powerful feature, but unfortunately do not have an efficient
implementation on the JVM. However -- due to an implementation quirk -- 
they provide a very nice shorthand for doing reflection.

	val obj: AnyRef
	obj.asInstanceOf[{def close()}].close()

## Error handling

Scala provides an exception facility, but do not use it for
commonplace errors, when the programmer must handle errors properly
for correctness. Instead, encode such errors explicitly: using
`Option` or `com.twitter.util.Try` are good, idiomatic choices, as
they harness the type system to ensure that the user is properly
considering error handling.

For example, when designing a repository, the following API may 
be tempting:

	trait Repository[Key, Value] {
	  def get(key: Key): Value
	}

.LP but this would require the implementor to throw an exception when the key is absent. A better approach is to use an <code>Option</code>:

	trait Repository[Key, Value] {
	  def get(key: Key): Option[Value]
	}

.LP This interface makes it obvious that the repository may not contain every key, and that the programmer must handle missing keys.  Furthermore, <code>Option</code> has a number of combinators to handle these cases. For example, <code>getOrElse</code> is used to supply a default value for missing keys:

	val repo: Repository[Int, String]
	repo.get(123) getOrElse "defaultString"

### Handling exceptions

Because Scala's exception mechanism isn't *checked* -- the compiler
cannot statically tell whether the programmer has covered the set of
possible exceptions -- it is often tempting to cast a wide net when
handling exceptions.

However, some exceptions are *fatal* and should never be caught; the
code

	try {
	  operation()
	} catch {
	  case _ => ...
	}

.LP is almost always wrong, as it would catch fatal errors that need to be propagated. Instead, use the <code>com.twitter.util.NonFatal</code> extractor to handle only nonfatal exceptions.

	try {
	  operation()
	} catch {
	  case NonFatal(exc) => ...
	}

## Garbage collection

We spend a lot of time tuning garbage collection in production. The
garbage collection concerns are largely similar to those of Java
though idiomatic Scala code tends to generate more (short-lived)
garbage than idiomatic Java code -- a byproduct of the functional
style. Hotspot's generational garbage collection typically makes this
a nonissue as short-lived garbage is effectively free in most circumstances.

Before tackling GC performance issues, watch
[this](http://www.infoq.com/presentations/JVM-Performance-Tuning-twitter)
presentation by Attila that illustrates some of our experiences with
GC tuning.

In Scala proper, your only tool to mitigate GC problems is to generate
less garbage; but do not act without data! Unless you are doing
something obviously degenerate, use the various Java profiling tools
-- our own include
[heapster](https://github.com/mariusaeriksen/heapster) and
[gcprof](https://github.com/twitter/jvmgcprof).

## Java compatibility

When we write code in Scala that is used from Java, we ensure
that usage from Java remains idiomatic. Oftentimes this requires
no extra effort -- classes and pure traits are exactly equivalent
to their Java counterpart -- but sometimes separate Java APIs
need to be provided. A good way to get a feel for your library's Java
API is to write a unittest in Java (just for compilation); this also ensures
that the Java-view of your library remains stable over time as the Scala
compiler can be volatile in this regard.

Traits that contain implementation are not directly
usable from Java: extend an abstract class with the trait
instead.

	// Not directly usable from Java
	trait Animal {
	  def eat(other: Animal)
	  def eatMany(animals: Seq[Animal) = animals foreach(eat(_))
	}
	
	// But this is:
	abstract class JavaAnimal extends Animal

## Twitter's standard libraries

The most important standard libraries at Twitter are
[Util](http://github.com/twitter/util) and
[Finagle](https://github.com/twitter/finagle). Util should be
considered an extension to the Scala and Java standard libraries, 
providing missing functionality or more appropriate implementations. Finagle
is our RPC system; the kernel distributed systems components.

### Futures

Futures have been <a href="#Concurrency-Futures">discussed</a>
briefly in the <a href="#Concurrency">concurrency section</a>. They 
are the central mechanism for coordination asynchronous
processes and are pervasive in our codebase and core to Finagle.
Futures allow for the composition of concurrent events, and simplifies
reasoning about highly concurrent operations. They also lend themselves
to a highly efficient implementation on the JVM.

Twitter's futures are *asynchronous*, so blocking operations --
basically any operation that can suspend the execution of its thread;
network IO and disk IO are examples -- must be handled by a system
that itself provides futures for the results of said operations.
Finagle provides such a system for network IO.

Futures are plain and simple: they hold the *promise* for the result
of a computation that is not yet complete. They are a simple container
-- a placeholder. A computation could fail of course, and this must 
also be encoded: a Future can be in exactly one of 3 states: *pending*,
*failed* or *completed*.

<div class="explainer">
<h3>Aside: <em>Composition</em></h3>
<p>Let's revisit what we mean by composition: combining simpler components
into more complicated ones. The canonical example of this is function
composition: Given functions <em>f</em> and
<em>g</em>, the composite function <em>(g&#8728;f)(x) = g(f(x))</em> &mdash; the result
of applying <em>x</em> to <em>f</em> first, and then the result of that
to <em>g</em> &mdash; can be written in Scala:</p>

<pre><code>val f = (i: Int) => i.toString
val g = (s: String) => s+s+s
val h = g compose f  // : Int => String
	
scala> h(123)
res0: java.lang.String = 123123123</code></pre>

.LP the function <em>h</em> being the composite. It is a <em>new</em> function that combines both <em>f</em> and <em>g</em> in a predefined way.
</div>

Futures are a type of collection -- they are a container of
either 0 or 1 elements -- and you'll find they have standard 
collection methods (eg. `map`, `filter`, and `foreach`). Since a Future's
value is deferred, the result of applying any of these methods
is necessarily also deferred; in

	val result: Future[Int]
	val resultStr: Future[String] = result map { i => i.toString }

.LP the function <code>{ i => i.toString }</code> is not invoked until the integer value becomes available, and the transformed collection <code>resultStr</code> is also in pending state until that time.

Lists can be flattened;

	val listOfList: List[List[Int]] = ..
	val list: List[Int] = listOfList.flatten

.LP and this makes sense for futures, too:

	val futureOfFuture: Future[Future[Int]] = ..
	val future: Future[Int] = futureOfFuture.flatten

.LP since futures are deferred, the implementation of <code>flatten</code> &mdash; it returns immediately &mdash; has to return a future that is the result of waiting for the completion of the outer future (<code><b>Future[</b>Future[Int]<b>]</b></code>) and after that the inner one (<code>Future[<b>Future[Int]</b>]</code>). If the outer future fails, the flattened future must also fail.

Futures (like Lists) also define `flatMap`; `Future[A]` defines its signature as

	flatMap[B](f: A => Future[B]): Future[B]
	
.LP which is like the combination of both <code>map</code> and <code>flatten</code>, and we could implement it that way:

	def flatMap[B](f: A => Future[B]): Future[B] = {
	  val mapped: Future[Future[B]] = this map f
	  val flattened: Future[B] = mapped.flatten
	  flattened
	}

This is a powerful combination! With `flatMap` we can define a Future that
is the result of two futures sequenced, the second future computed based
on the result of the first one. Imagine we needed to do two RPCs in order
to authenticate a user (id), we could define the composite operation in the
following way:

	def getUser(id: Int): Future[User]
	def authenticate(user: User): Future[Boolean]
	
	def isIdAuthed(id: Int): Future[Boolean] = 
	  getUser(id) flatMap { user => authenticate(user) }

.LP an additional benefit to this type of composition is that error handling is built-in: the future returned from <code>isAuthed(..)</code> will fail if either of <code>getUser(..)</code> or <code>authenticate(..)</code> does with no extra error handling code.

#### Style

Future callback methods (`respond`, `onSuccess`, `onFailure`, `ensure`)
return a new future that is *chained* to its parent. This future is guaranteed
to be completed only after its parent, enabling patterns like

	acquireResource()
	future onSuccess { value =>
	  computeSomething(value)
	} ensure {
	  freeResource()
	}

.LP where <code>freeResource()</code> is guaranteed to be executed only after <code>computeSomething</code>, allowing for emulation of the native <code>try .. finally</code> pattern.

Use `onSuccess` instead of `foreach` -- it is symmetrical to `onFailure` and
is a better name for the purpose, and also allows for chaining.

Always try to avoid creating `Promise` instances directly: nearly every task
can be accomplished via the use of predefined combinators. These
combinators ensure errors and cancellations are propagated, and generally
encourage *dataflow style* programming which usually <a
href="#Concurrency-Futures">obviates the need for synchronization and
volatility declarations</a>.

Code written in tail-recursive style is not subject to stack-space leaks,
allowing for efficient implementation of loops in dataflow-style:

	case class Node(parent: Option[Node], ...)
	def getNode(id: Int): Future[Node] = ...

	def getHierarchy(id: Int, nodes: List[Node] = Nil): Future[Node] =
	  getNode(id) flatMap {
	    case n@Node(Some(parent), ..) => getHierarchy(parent, n :: nodes)
	    case n => Future.value((n :: nodes).reverse)
	  }

`Future` defines many useful methods: Use `Future.value()` and
`Future.exception()` to create pre-satisfied futures.
`Future.collect()`, `Future.join()` and `Future.select()` provide
combinators that turn many futures into one (ie. the gather part of a
scatter-gather operation).

#### Cancellation

Futures implement a weak form of cancellation. Invoking `Future#cancel`
does not directly terminate the computation but instead propagates a
level triggered *signal* that may be queried by whichever process
ultimately satisfies the future. Cancellation flows in the opposite
direction from values: a cancellation signal set by a consumer is
propagated to its producer. The producer uses `onCancellation` on
`Promise` to listen to this signal and act accordingly.

This means that the cancellation semantics depend on the producer,
and there is no default implementation. *Cancellation is but a hint*.

#### Locals

Util's
[`Local`](https://github.com/twitter/util/blob/master/util-core/src/main/scala/com/twitter/util/Local.scala#L40)
provides a reference cell that is local to a particular future dispatch tree. Setting the value of a local makes this
value available to any computation deferred by a Future in the same thread. They are analogous to thread locals,
except their scope is not a Java thread but a tree of "future threads". In

	trait User {
	  def name: String
	  def incrCost(points: Int)
	}
	val user = new Local[User]

	...

	user() = currentUser
	rpc() ensure {
	  user().incrCost(10)
	}

.LP <code>user()</code> in the <code>ensure</code> block will refer to the value of the <code>user</code> local at the time the callback was added.

As with thread locals, `Local`s can be very convenient, but should
almost always be avoided: make sure the problem cannot be sufficiently
solved by passing data around explicitly, even if it is somewhat
burdensome.

Locals are used effectively by core libraries for *very* common 
concerns -- threading through RPC traces, propagating monitors,
creating "stack traces" for future callbacks -- where any other solution
would unduly burden the user. Locals are inappropriate in almost any
other situation.

### Offer/Broker

Concurrent systems are greatly complicated by the need to coordinate
access to shared data and resources.
[Actors](http://www.scala-lang.org/api/current/scala/actors/Actor.html)
present one strategy of simplification: each actor is a sequential process
that maintains its own state and resources, and data is shared by
messaging with other actors. Sharing data requires communicating between
actors.

Offer/Broker builds on this in three important ways. First,
communication channels (Brokers) are first class -- that is, you send
messages via Brokers, not to an actor directly. Secondly, Offer/Broker
is a synchronous mechanism: to communicate is to synchronize. This
means we can use Brokers as a coordination mechanism: when process `a`
has sent a message to process `b`; both `a` and `b` agree on the state
of the system. Lastly, communication can be performed *selectively*: a
process can propose several different communications, and exactly one
of them will obtain.

In order to support selective communication (as well as other
composition) in a general way, we need to decouple the description of
a communication from the act of communicating. This is what an `Offer`
does -- it is a persistent value that describes a communication; in
order to perform that communication (act on the offer), we synchronize
via its `sync()` method

	trait Offer[T] {
	  def sync(): Future[T]
	}

.LP which returns a <code>Future[T]</code> that yields the exchanged value when the communication obtains.

A `Broker` coordinates the exchange of values through offers -- it is the channel of communications:

	trait Broker[T] {
	  def send(msg: T): Offer[Unit]
	  val recv: Offer[T]
	}

.LP so that, when creating two offers

	val b: Broker[Int]
	val sendOf = b.send(1)
	val recvOf = b.recv

.LP and <code>sendOf</code> and <code>recvOf</code> are both synchronized

	// In process 1:
	sendOf.sync()

	// In process 2:
	recvOf.sync()

.LP both offers obtain and the value <code>1</code> is exchanged.

Selective communication is performed by combining several offers with
`Offer.choose`

	def choose[T](ofs: Offer[T]*): Offer[T]

.LP which yields a new offer that, when synchronized, obtains exactly one of <code>ofs</code> &mdash; the first one to become available. When several are available immediately, one is chosen at random to obtain.

The `Offer` object has a number of one-off Offers that are used to compose with Offers from a Broker.

	Offer.timeout(duration): Offer[Unit]

.LP Is an offer that activates after the given duration. <code>Offer.never</code> will never obtain, and <code>Offer.const(value)</code> obtains immediately with the given value. These are useful for composition via selective communication. For example to apply a timeout on a send operation:

	Offer.choose(
	  Offer.timeout(10.seconds),
	  broker.send("my value")
	).sync()

It may be tempting to compare the use of Offer/Broker to
[SynchronousQueue](http://docs.oracle.com/javase/6/docs/api/java/util/concurrent/SynchronousQueue.html),
but they are different in subtle but important ways. Offers can be composed in ways that such queues simply cannot. For example, consider a set of queues, represented as Brokers:

	val q0 = new Broker[Int]
	val q1 = new Broker[Int]
	val q2 = new Broker[Int]
	
.LP Now let's create a merged queue for reading:

	val anyq: Offer[Int] = Offer.choose(q0.recv, q1.recv, q2.recv)
	
.LP <code>anyq</code> is an offer that will read from first available queue. Note that <code>anyq</code> is <em>still synchronous</em> &mdash; we still have the semantics of the underlying queues. Such composition is simply not possible using queues.
	
#### Example: A Simple Connection Pool

Connection pools are common in network applications, and they're often
tricky to implement -- for example, it's often desirable to have
timeouts on acquisition from the pool since various clients have different latency
requirements. Pools are simple in principle: we maintain a queue of
connections, and we satisfy waiters as they come in. With traditional
synchronization primitives this typically involves keeping two queues:
one of waiters (when there are no connections), and one of connections
(when there are no waiters).

Using Offer/Brokers, we can express this quite naturally:

	class Pool(conns: Seq[Conn]) {
	  private[this] val waiters = new Broker[Conn]
	  private[this] val returnConn = new Broker[Conn]

	  val get: Offer[Conn] = waiters.recv
	  def put(c: Conn) { returnConn ! c }
	
	  private[this] def loop(connq: Queue[Conn]) {
	    Offer.choose(
	      if (connq.isEmpty) Offer.never else {
	        val (head, rest) = connq.dequeue
	        waiters.send(head) { _ => loop(rest) }
	      },
	      returnConn.recv { c => loop(connq enqueue c) }
	    ).sync()
	  }
	
	  loop(Queue.empty ++ conns)
	}

`loop` will always offer to have a connection returned, but only offer
to send one when the queue is nonempty. Using a persistent queue simplifies
reasoning further. The interface to the pool is also through an Offer, so if a caller
wishes to apply a timeout, they can do so through the use of combinators:

	val conn: Future[Option[Conn]] = Offer.choose(
	  pool.get { conn => Some(conn) },
	  Offer.timeout(1.second) { _ => None }
	).sync()

No extra bookkeeping was required to implement timeouts; this is due to
the semantics of Offers: if `Offer.timeout` is selected, there is no
longer an offer to receive from the pool -- the pool and its caller
never simultaneously agreed to receive and send, respectively, on the
`waiters` broker.

#### Example: Sieve of Eratosthenes

It is often useful -- and sometimes vastly simplifying -- to structure
concurrent programs as a set of sequential processes that communicate
synchronously. Offers and Brokers provide a set of tools to make this simple
and uniform. Indeed, their application transcends what one might think
of as "classic" concurrency problems -- concurrent programming (with
the aid of Offer/Broker) is a useful *structuring* tool, just as
subroutines, classes, and modules are -- another important 
idea from CSP.

One example of this is the [Sieve of
Eratosthenes](http://en.wikipedia.org/wiki/Sieve_of_Eratosthenes),
which can be structured as a successive application of filters to a
stream of integers. First, we'll need a source of integers:

	def integers(from: Int): Offer[Int] = {
	  val b = new Broker[Int]
	  def gen(n: Int): Unit = b.send(n).sync() ensure gen(n + 1)
	  gen(from)
	  b.recv
	}

.LP <code>integers(n)</code> is simply the offer of all consecutive integers starting at <code>n</code>. Then we need a filter:

	def filter(in: Offer[Int], prime: Int): Offer[Int] = {
	  val b = new Broker[Int]
	  def loop() {
	    in.sync() onSuccess { i =>
	      if (i % prime != 0)
	        b.send(i).sync() ensure loop()
	      else
	        loop()
	    }
	  }
	  loop()
	
	  b.recv
	}

.LP <code>filter(in, p)</code> returns the offer that removes multiples of the prime <code>p</code> from <code>in</code>. Finally, we define our sieve:

	def sieve = {
	  val b = new Broker[Int]
	  def loop(of: Offer[Int]) {
	    for (prime <- of.sync(); _ <- b.send(prime).sync())
	      loop(filter(of, prime))
	  }
	  loop(integers(2))
	  b.recv
	}

.LP <code>loop()</code> works simply: it reads the next (prime) number from <code>of</code>, and then applies a filter to <code>of</code> that excludes this prime. As <code>loop</code> recurses, successive primes are filtered, and we have a Sieve. We can now print out the first 10000 primes:

	val primes = sieve
	0 until 10000 foreach { _ =>
	  println(primes.sync()())
	}

Besides being structured into simple, orthogonal components, this
approach gives you a streaming Sieve: you do not a-priori need to
compute the set of primes you are interested in, further enhancing
modularity.

## Acknowledgments

The lessons herein are those of Twitter's Scala community -- I hope
I've been a faithful chronicler.

Blake Matheny, Nick Kallen, Steve Gury, and Raghavendra Prabhu
provided much helpful guidance and many excellent suggestions.

[Scala]: http://www.scala-lang.org/
[Finagle]: http://github.com/twitter/finagle
[Util]: http://github.com/twitter/util
[pimp my library]: http://www.artima.com/weblogs/viewpost.jsp?thread=179766
[generalized type constraints]: http://www.dzone.com/links/r/using_generalized_type_constraints_how_to_remove.html
[type evidence]: http://stackoverflow.com/questions/3427345/what-do-and-mean-in-scala-2-8-and-where-are-they-documented
[Manifest][http://www.scala-lang.org/api/current/index.html#scala.reflect.Manifest]