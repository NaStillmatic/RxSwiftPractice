import RxSwift
import Foundation

let disposeBag = DisposeBag()

enum TraitsError: Error {
  case single
  case maybe
  case completable
}

print("--------Single1---------")

Single<String>.just("✅")
  .subscribe(
    onSuccess: {
      print($0)
    },
    onFailure: {
      print("error \($0)")
    },
    onDisposed: {
      print("disposed")
    }
  )
  .disposed(by: disposeBag)

print("--------Single2---------")

Observable<String>.create { observer -> Disposable in
  observer.onError(TraitsError.single)
  return Disposables.create()
}
.asSingle()
.subscribe(
  onSuccess: {
    print($0)
  },
  onFailure: {
    print("error \($0)")
  },
  onDisposed: {
    print("disposed")
  }
)
.disposed(by: disposeBag)


print("--------Single3---------")

struct SomeJSON: Decodable {
  let name: String
  
}

enum JSONError: Error {
  case decodingError
}

let json1 = """
            {"name" : "park"}
            """

let json2 = """
            {"my_name" : "young"}
            """


func decode(json: String) -> Single<SomeJSON> {
  Single<SomeJSON>.create { observer -> Disposable in
    guard let data = json.data(using: .utf8),
          let json = try? JSONDecoder().decode(SomeJSON.self, from: data) else {
      observer(.failure(JSONError.decodingError))
      return Disposables.create()
    }
    observer(.success(json))
    return Disposables.create()
  }
}


decode(json: json1)
  .subscribe {
    switch $0 {
    case .success(let json):
      print(json.name)
    case .failure(let error):
      print(error)
    }
  }
  .disposed(by: disposeBag)


decode(json: json2)
  .subscribe {
    switch $0 {
    case .success(let json):
      print(json.name)
    case .failure(let error):
      print(error)
    }
  }
  .disposed(by: disposeBag)


print("---------Maybe1---------")

Maybe<String>.just("✅")
  .subscribe(
    onSuccess: {
      print($0)
    },
    onError: {
      print($0)
    },
    onCompleted: {
      print("completed")
    },
    onDisposed: {
      print("disposed")
    }
  )
  .disposed(by: disposeBag)



print("---------Maybe2---------")

Observable<String>.create { observer -> Disposable in
  observer.onError(TraitsError.maybe)
  return Disposables.create()
}
.asMaybe()
.subscribe(
  onSuccess: {
    print("성공: \($0)")
  }, onError: {
    print("에러: \($0)")
  }, onCompleted: {
    print("completed")
  }, onDisposed: {
    print("disposed")
  }
)
.disposed(by: disposeBag)



print("---------Completable1---------")

Completable.create { observer -> Disposable in
  observer(.error(TraitsError.completable))
  return Disposables.create()
}
.subscribe(
  onCompleted: {
    print("completed")
  }, onError: {
    print("error: \($0)")
  }, onDisposed: {
    print("disposed")
  }
)
.disposed(by: disposeBag)

print("---------Completable2---------")
Completable.create { observer -> Disposable in
  observer(.completed)
  return Disposables.create()
}
.subscribe {
  print($0)
}
.disposed(by: disposeBag)


print("---------switchLatest---------")

let 👩🏼‍💻학생1 = PublishSubject<String>()
let 🧑🏻‍💻학생2 = PublishSubject<String>()
let 👨🏾‍💻학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>()

let 손든사람만말할수있는교실 = 손들기.switchLatest()

손든사람만말할수있는교실
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)

손들기.onNext(👩🏼‍💻학생1)
👩🏼‍💻학생1.onNext("👩🏼‍💻학생1: 저는 1번 학생입니다.")
🧑🏻‍💻학생2.onNext("🧑🏻‍💻학생2: 저요 저요!!!")

손들기.onNext(🧑🏻‍💻학생2)

🧑🏻‍💻학생2.onNext("🧑🏻‍💻학생2: 저는 2번이에요!")
👩🏼‍💻학생1.onNext("👩🏼‍💻학생1: 아.. 나 아직 할말 있는데")

손들기.onNext(👨🏾‍💻학생3)

🧑🏻‍💻학생2.onNext("🧑🏻‍💻학생2: 아니 잠깐만! 내가!")
👩🏼‍💻학생1.onNext("👩🏼‍💻학생1: 언제 말할 수 있죠")
👨🏾‍💻학생3.onNext("👨🏾‍💻학생3: 저는 3번입니다~ 아무래도 제가 이긴 것 같네요.")

손들기.onNext(👩🏼‍💻학생1)

👩🏼‍💻학생1.onNext("👩🏼‍💻학생1: 아니, 틀렸어, 승자는 나야.")
🧑🏻‍💻학생2.onNext("🧑🏻‍💻학생2: ㅠㅠ")
👨🏾‍💻학생3.onNext("👨🏾‍💻학생3: 이긴 줄 알았는데")
🧑🏻‍💻학생2.onNext("🧑🏻‍💻학생2: 이거 이기고 지는 손들기였나요?")


print("---------reduce---------")

Observable.from(1...10)
//  .reduce(0, accumulator: { summary, newValue in
//      return summary + newValue
//  })
//  .reduce(0) { summary, newValue in
//    return summary + newValue
//  }
  .reduce(0, accumulator: +)
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)


print("---------scan---------")

Observable.from(1...10)
  .scan(0, accumulator: +)
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)
