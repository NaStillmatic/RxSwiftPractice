import UIKit
import RxSwift

let disposeBag = DisposeBag()

print("-----------startWith-------------")

let λΈλλ° = Observable<String>.of("π§π»", "π¦πΌ", "π¦π»")

λΈλλ°
  .enumerated()
  .map { index, element in
    element + "μ΄λ¦°μ΄" + "\(index)"
  }
  .startWith("π§π»ββοΈμ μλ")
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)



print("-----------concat1-------------")

let λΈλλ°μ΄λ¦°μ΄λ€ = Observable<String>.of("π§π»", "π¦πΌ", "π¦π»")
let μ μλ = Observable<String>.of("π§π»ββοΈμ μλ")

let μ€μμκ±·κΈ° = Observable.concat([μ μλ, λΈλλ°μ΄λ¦°μ΄λ€])

μ€μμκ±·κΈ°
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)

print("-----------concat2-------------")

μ μλ
  .concat(λΈλλ°μ΄λ¦°μ΄λ€)
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)


print("-----------concatMap-------------")

let μ΄λ¦°μ΄μ§: [String : Observable<String>] = [
  "λΈλλ°" : Observable.of("π§π»", "π¦πΌ", "π¦π»"),
  "νλλ°" : Observable.of("πΆπ»", "πΆπΌ")
]

Observable.of("λΈλλ°", "νλλ°")
  .concatMap { λ° in
    μ΄λ¦°μ΄μ§[λ°] ?? .empty()
  }
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)


print("-----------merge1-------------")

let κ°λΆ = Observable.from(["κ°λΆκ΅¬", "μ±λΆκ΅¬", "λλλ¬Έκ΅¬", "μ’λ‘κ΅¬"])
let κ°λ¨ = Observable.from(["κ°λ¨κ΅¬", "κ°λκ΅¬", "μλ±ν¬κ΅¬", "μμ²κ΅¬"])

Observable.of(κ°λΆ, κ°λ¨)
  .merge()
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)


print("-----------merge2-------------")

Observable.of(κ°λΆ, κ°λ¨)
  .merge(maxConcurrent:1)
  .subscribe(onNext:{
    print($0)
  })
  .disposed(by: disposeBag)

print("-----------combineLatest1-------------")

let μ± = PublishSubject<String>()
let μ΄λ¦ = PublishSubject<String>()

let μ±λͺ = Observable
  .combineLatest(μ±, μ΄λ¦) { μ±, μ΄λ¦ in
    μ± + μ΄λ¦
  }

μ±λͺ
  .subscribe(onNext:{
    print($0)
  })
  .disposed(by: disposeBag)


μ±.onNext("κΉ")
μ΄λ¦.onNext("λλ")
μ΄λ¦.onNext("μμ")
μ΄λ¦.onNext("μμ")
μ±.onNext("λ°")
μ±.onNext("μ΄")
μ±.onNext("μ‘°")

print("-----------combineLatest2-------------")

let λ μ§νμνμ = Observable<DateFormatter.Style>.of(.short, .long)
let νμ¬λ μ§ = Observable<Date>.of(Date())

let νμ¬λ μ§νμ = Observable
  .combineLatest(
    λ μ§νμνμ,
    νμ¬λ μ§,
    resultSelector: { νμ, λ μ§ -> String in
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = νμ
      return dateFormatter.string(from: λ μ§)
    }
  )

νμ¬λ μ§νμ
  .subscribe(onNext: {
      print($0)
    }
  )
  .disposed(by: disposeBag)


print("-----------combineLatest3-------------")

let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullName = Observable
  .combineLatest([firstName, lastName]) { name in
    name.joined(separator: " ")
  }

fullName
  .subscribe(onNext:{
    print($0)
  })
  .disposed(by: disposeBag)

lastName.onNext("Kim")
firstName.onNext("Paul")
firstName.onNext("Stella")
firstName.onNext("Lily")

print("-----------zip-------------")

enum μΉν¨ {
  case μΉ
  case ν¨
}

let μΉλΆ = Observable<μΉν¨>.of(.μΉ, .μΉ, .ν¨, .μΉ, .ν¨)
let μ μ = Observable<String>.of("π°π·", "π¨π­", "πΊπΈ", "π§π·", "π―π΅", "π¨π³")

let μν©κ²°κ³Ό = Observable
  .zip(μΉλΆ, μ μ) {  κ²°κ³Ό, λνμ μ in
    return λνμ μ + "μ μ" + " \(κ²°κ³Ό)"
  }

μν©κ²°κ³Ό
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)



print("-----------withLatestFrom1-------------")

let π₯π« = PublishSubject<Void>()
let λ¬λ¦¬κΈ°μ μ = PublishSubject<String>()

π₯π«
  .withLatestFrom(λ¬λ¦¬κΈ°μ μ)
//  .distinctUntilChanged() // withLatestFrom1 κ³Ό λμΌν κ²°κ³Ό
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)

λ¬λ¦¬κΈ°μ μ.onNext("ππ»ββοΈ")
λ¬λ¦¬κΈ°μ μ.onNext("ππ»ββοΈ πββοΈ")
λ¬λ¦¬κΈ°μ μ.onNext("ππ»ββοΈ πββοΈ π")

π₯π«.onNext(Void())
π₯π«.onNext(Void())


print("-----------withLatestFrom1-------------")

let πμΆλ° = PublishSubject<Void>()
let F1μ μ = PublishSubject<String>()

F1μ μ
  .sample(πμΆλ°)
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)

F1μ μ.onNext("π")
F1μ μ.onNext("π  π")
F1μ μ.onNext("π     π   π")

πμΆλ°.onNext(Void())
πμΆλ°.onNext(Void())
πμΆλ°.onNext(Void())



print("-----------amb-------------")

let πλ²μ€1 = PublishSubject<String>()
let πλ²μ€2 = PublishSubject<String>()
                                   
let πλ²μ€μ λ₯μ₯ = πλ²μ€1.amb(πλ²μ€2)

πλ²μ€μ λ₯μ₯
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)

πλ²μ€2.onNext("λ²μ€2-μΉκ°0: π©π»βπΌ")
πλ²μ€1.onNext("λ²μ€1-μΉκ°0: π¨πΌβπΌ")
πλ²μ€1.onNext("λ²μ€1-μΉκ°1: π§π»ββοΈ")
πλ²μ€2.onNext("λ²μ€2-μΉκ°1: π¨π»βπΌ")
πλ²μ€1.onNext("λ²μ€1-μΉκ°2: π§πΌββοΈ")
πλ²μ€2.onNext("λ²μ€2-μΉκ°2: π©π½βπΌ")


