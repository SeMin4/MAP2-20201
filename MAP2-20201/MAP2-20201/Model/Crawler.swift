//
//  Crawler.swift
//  MAP2-20201
//
//  Created by pcrmcw0486 on 2020/04/21.
//  Copyright © 2020 COMP420. All rights reserved.
//

import Foundation
import SwiftSoup

//crawler 싱글톤 객체로 생성하여 ~> 게터 세터가 필요한가? 천천히 생각해본다.
//싱글톤을 사용하는 이유는 메모리 낭비를 방지하고 데이터를 공유하는데 있다.
//싱글톤 객체 생성 방법 참조 링크
//http://throughkim.kr/2019/09/04/swift-singleton/
//https://linsaeng.tistory.com/9
//https://velog.io/@naroti/iOS-%EA%B0%9C%EB%B0%9C-Singleton-Pattern-q4k3uzgf0n
//이후 싱글톤 관련해서는 다시 코딩함. (04.27) ~> Crawler.swift && Person_info.swift
//04.27 중복되는 코드 및 모델링에 있어서 뭔가 마음에 안드는데 고쳐나갈예정.

class Crawler
{
    //typealias notice = Notice;
    //static 전역 변수로 선언하는데 이 프로퍼티는 지연생성(lazy)되기 때문에 처음 클래스를 생성하기까지는
    //메모리에 올라가지 않는다
    
    static let shared = Crawler()
    
    // private var url : String = ""
    
    //생성자를 private으로 제한해서 외부에서 인스턴스를 생성하지 못하도록 강제하여, 유니크한 싱글톤을 만든다.
    private init() {}
    //Download HTML
    func downloadHTML(input_URL : String) -> Document?{
        var document: Document = Document.init("")
        // url string to URL
        guard let url = URL(string: input_URL ) else {
            // an error occurred
            print("Error: \(input_URL) doesn't seem to be a valid URL")
            return nil
        }
        
        do {
            // content of url
            let html = try String.init(contentsOf: url)
            //html 문서 다운로드
            // print(html)
            // parse it into a Document
            //document 로 변환 일단 파싱함.
            document = try SwiftSoup.parse(html)
            // parse css query
            //주어진 css query 로 파싱함.
        } catch let error {
            // an error occurred
            print("Error: \(error)")
        }
        return document
    }
    
    //knu.ac.kr 본관 공지 크롤링
    func knu_notice_crawl(URL : String?) -> [Notice]?
    {
        var document : Document?
        let url = URL ?? "http://knu.ac.kr/wbbs/wbbs/bbs/btin/list.action?bbs_cde=1&menu_idx=67"
        document = downloadHTML(input_URL: url) ?? nil
        if(document == nil){
            return nil
        }
        var notices = [Notice]()
        let selector = "tbody>tr"
        do {
            //여기서  element객체를 css selector를 통해 파싱해서 element에 넣어줌.
            let elements: Elements = try document!.select(selector )
            //transform it into a local object (Item)
            for element in elements {
                let num = try element.select(".num").text();
                               let title = try element.select("a").text()
                               let ref : String =  try element.select("a").attr("href")
                               let writer = try element.select(".writer").text()
                               let date = try element.select(".date").text()
                               let hit = try element.select(".hit").text()
                               let file = try element.select(".file").text().elementsEqual("")
                notices.append(Notice(num: num,title: title,ref: ref,wrtier: writer,date: date,hit: hit,file: file))
            }
            
        } catch let error {
            print("Error: \(error)")
        }
         return notices
    }
    
    //computer.knu.ac.kr 전체공지
    func computer_total_notice_crawl(URL : String?) -> [Notice]?
    {
        var document : Document?
        let url = URL ?? "http://computer.knu.ac.kr/06_sub/02_sub_2.html"
        document = downloadHTML(input_URL: url) ?? nil
        if(document == nil){
            return nil
        }
        var notices = [Notice]()
        let selector = "tbody>tr"
        do {
            //여기서  element객체를 css selector를 통해 파싱해서 element에 넣어줌.
            let elements: Elements = try document!.select(selector )
            //transform it into a local object (Item)
            for element in elements {
                let num = try element.select(".bbs_num").text();
                let title = try element.select("a").text()
                let ref : String =  try element.select("a").attr("href")
                let writer = try element.select(".bbs_writer").text()
                let date = try element.select(".bbs_date").text()
                let hit = try element.select(".bbs_hit").text()
                let file = false
                notices.append(Notice(num: num,title: title,ref: ref,wrtier: writer,date: date,hit: hit,file: file))
             //   print("num = \(num)" , "title = \(title)" , "title_to = \(ref)" , "writer = \(writer)" ,"date = \(date)" ,"hit = \(hit)" , "file 유무 : \(file)",separator : "\n")
               // print("========================================================")
            }
            
        } catch let error {
            print("Error: \(error)")
        }
         return notices
    }
    
   //computer.knu.ac.kr 학부공지
    func computer_major_notice_crawl(URL : String?) -> [Notice]?
   {
       var document : Document?
       let url = URL ?? "http://computer.knu.ac.kr/06_sub/02_sub_2.html"
       document = downloadHTML(input_URL: url) ?? nil
       if(document == nil){
           return nil
       }
       var notices = [Notice]()
       let selector = "tbody>tr"
       do {
           //여기서  element객체를 css selector를 통해 파싱해서 element에 넣어줌.
           let elements: Elements = try document!.select(selector )
           //transform it into a local object (Item)
           for element in elements {
               let num = try element.select(".bbs_num").text();
               let title = try element.select("a").text()
               let ref : String =  try element.select("a").attr("href")
               let writer = try element.select(".bbs_writer").text()
               let date = try element.select(".bbs_date").text()
               let hit = try element.select(".bbs_hit").text()
               let file = false
               notices.append(Notice(num: num,title: title,ref: ref,wrtier: writer,date: date,hit: hit,file: file))
            //   print("num = \(num)" , "title = \(title)" , "title_to = \(ref)" , "writer = \(writer)" ,"date = \(date)" ,"hit = \(hit)" , "file 유무 : \(file)",separator : "\n")
              // print("========================================================")
           }
           
       } catch let error {
           print("Error: \(error)")
       }
        return notices
   }
    
    func academic_calendar_crawl()
    {
        
    }
    
    func curriculum_crawl()
    {
        
    }
    
    func time_table_crawl()
    {
        
    }
    
    func grade_crawl()
    {
        
    }
    
    func mileage_crawl()
    {
        
    }
}
