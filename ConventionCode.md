
</a><h1>Tên project(Product Name)</h1>
Cũng như tên biến sử dụng quy tắc con lạc đà, chỉ khác ở chỗ, chữ cái đầu viết hoa. Ví dụ "ConventionCodeDemo".</p>
</li>
<ul>
<li>
<p>Organization Name: Sử dụng "5skay".</p>
</li>
<li><p>Organization identifier:
Sử dụng "com.5skay".</p></li>
<li>
<p>Class Prefix:
Tiền tố mặc định được thêm vào tên các file khi được thêm mới vào project. Tùy dự án, đặt tên file này khác nhau. Ví dụ tên dự án là "ConventionCodeDemo" Class Prefix có thể là "C" hoặc "CC".</p>
</li>
</ul>
<h1><a id="user-content-cấu-trúc-thư-mục-project" class="anchor" href="#cấu-trúc-thư-mục-project" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Cấu trúc thư mục project</h1>
<p>Các thư mục con được tạo để trong thư mục project, ví dụ project có tên là "ConventionCodeDemo" khi được tạo sẽ kèm theo thư mục con là "ConventionCodeDemo", các thư sau sẽ được tạo trong thư mục này.</p>
<ol>
<li>
<p>Libraries:
Thư mục này sẽ chứa các thư viện nhúng được kéo từ ngoài vào project.</p>
</li>
<li>
<p>Resources:
Chứa các file media, plist....</p>
</li>
</ol>
<p>Tổ chức thành các thư mục như sau:</p>
<ul>
<li>
<p>Videos:
Chứa các file video</p>
</li>
<li>
<p>Plists:
Chứa các file plist</p>
</li>
</ul>
<p><code>Các file hình ảnh để trong Assets.xcassets**</code></p>
<ol start="3">
<li>Classes:
Thư mục chính của project, chứa code của thành viên trong team. Gồm các thư mục sau:</li>
</ol>
<ul>
<li>
<p>Models
Chứa các file model</p>
</li>
<li>
<p>Objects
Chứa các file objects</p>
</li>
<li>
<p>Services
Chứa các file services tổ chức các API</p>
</li>
<li>
<p>Helpers
Chứa các file cấu hình như Constants...</p>
</li>
<li>
<p>Extensions
Chứa các file extension, mở rộng chức năng của các đối tượng</p>
</li>
<li>
<p>ViewControllers
Chứa các ViewController của project, mỗi một cụm chức năng nên được tổ chức thành từng thư mục riêng, trong mỗi thư mục này, các màn hình tương ứng với mỗi ViewController cũng phải được tổ chức thành các thư mục riêng rẽ như vậy. Chú ý với trường hợp các ViewController có sử dụng customCell thì trong mỗi thư mục ViewController riêng tạo 1 thư mục CustomCell , không gôp chung tất cả với nhau .</p>
</li>
<li>
<p>CustomViews
Chứa các view do developer tự custom.</p>
</li>
</ul>
<h1><a id="user-content-một-số-quy-tắc-tổ-chức-code" class="anchor" href="#một-số-quy-tắc-tổ-chức-code" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Một số quy tắc tổ chức code</h1>
<p>Các file viewController
Phân thành các đoạn sau sử dụng:<code>// MARK: -</code></p>
<ul>
<li>Variable and IBOutlet :
(Phần khai báo biến)</li>
</ul>
<p>Tổ chức thành từng đoạn theo từng cụm view, hoặc //từng chức năng. Tạo comment cho từng cụm, mỗi cụm cách nhau bởi một dòng trống, trong mỗi cụm sắp xếp theo thứ tự abc. Ví dụ:</p>
<div class="highlight highlight-source-swift"><pre><span class="pl-c"><span class="pl-c">//</span> MARK: - Variable and IBOutlet</span>
<span class="pl-c"></span>
<span class="pl-c"><span class="pl-c">
//</span>Main View</span>

<span class="pl-c"></span><span class="pl-k">@IBOutlet</span> <span class="pl-k">var</span> containerView<span class="pl-k">:</span> UIView<span class="pl-k">!</span>
<span class="pl-k">@IBOutlet</span> <span class="pl-k">var</span> imageViewHeader<span class="pl-k">:</span> UIImageView<span class="pl-k">!</span>
<span class="pl-k">@IBOutlet</span> <span class="pl-k">var</span> labelHeader<span class="pl-k">:</span> UITextView<span class="pl-k">!</span>
<span class="pl-k">@IBOutlet</span> <span class="pl-k">var</span> labelTitle<span class="pl-k">:</span> UILabel<span class="pl-k">!</span>
<span class="pl-k">@IBOutlet</span> <span class="pl-k">var</span> scrollBackground<span class="pl-k">:</span> UIScrollView<span class="pl-k">!</span>

<span class="pl-c"><span class="pl-c">
//</span> Registration View</span>
<span class="pl-c"></span><span class="pl-k">@IBOutlet</span> <span class="pl-k">var</span> labelEmail<span class="pl-k">:</span> UILabel<span class="pl-k">!</span>
<span class="pl-k">@IBOutlet</span> <span class="pl-k">var</span> labelLimitCharacterNickname<span class="pl-k">:</span> UILabel<span class="pl-k">!</span>
<span class="pl-k">@IBOutlet</span> <span class="pl-k">var</span> labelNickname<span class="pl-k">:</span> UILabel<span class="pl-k">!</span>
<span class="pl-k">@IBOutlet</span> <span class="pl-k">var</span> textFieldEmail<span class="pl-k">:</span> UITextField<span class="pl-k">!</span>
<span class="pl-k">@IBOutlet</span> <span class="pl-k">var</span> textFieldNickname<span class="pl-k">:</span> UITextField<span class="pl-k">!</span>
<span class="pl-k">@IBOutlet</span> <span class="pl-k">var</span> textViewRegistration<span class="pl-k">:</span> UITextView<span class="pl-k">!</span>
<span class="pl-c"><span class="pl-c">

//</span> Custom variable</span>
<span class="pl-c"></span><span class="pl-k">var</span> areaList<span class="pl-k">:</span> [AreaModel] <span class="pl-k">=</span> []
<span class="pl-k">var</span> areaSelected<span class="pl-k">:</span> AreaModel<span class="pl-k">!</span>
<span class="pl-k">var</span> licenseList<span class="pl-k">:</span> [LicenseModel] <span class="pl-k">=</span> []
<span class="pl-k">var</span> licenseSelected<span class="pl-k">:</span> LicenseModel<span class="pl-k">!</span></pre></div>
<ul>

<li>Cycle function:
(Các function mặc định, chu kì hoạt động của các view controller)</li>
</ul>
<p>Không thực hiện trực tiếp khởi tạo các thành phần trong viewDidLoad, mà tổ chức thành hai hàm initComponent() và initData(). VD:</p>
<div class="highlight highlight-source-swift"><pre><span class="pl-c"><span class="pl-c">//</span>MARK: - Life cycle</span>
<span class="pl-c"></span><span class="pl-k">override</span> <span class="pl-k">func</span> <span class="pl-en">viewDidLoad</span>() {
<span class="pl-c1">super</span>.<span class="pl-c1">viewDidLoad</span>()

<span class="pl-c1">initComponent</span>()
<span class="pl-c1">initData</span>()
}
<span class="pl-k">override</span> <span class="pl-k">func</span> <span class="pl-en">viewWillAppear</span>(<span class="pl-smi"><span class="pl-en">animated</span></span>: <span class="pl-c1">Bool</span>)  {
<span class="pl-c1">super</span>.<span class="pl-c1">viewWillAppear</span>(animated)

}

<span class="pl-k">override</span> <span class="pl-k">func</span> <span class="pl-en">viewDidLayoutSubviews</span>()  {

}
<span class="pl-k">override</span> <span class="pl-k">func</span> <span class="pl-en">didReceiveMemoryWarning</span>() {

}
</pre></div>
<ul>
<li>Custom function, call API:</li>
</ul>
<p>(Các hàm khởi tạo, gọi API)</p>
<p>…Tổ chức các hàm, sắp xếp theo thứ tự abc. VD:</p>
<div class="highlight highlight-source-swift"><pre><span class="pl-c"><span class="pl-c">//</span>MARK: - Init </span>
<span class="pl-c"></span><span class="pl-k">func</span> <span class="pl-en">initComponent</span>() { 

}

<span class="pl-k">func</span> <span class="pl-en">initData</span>() {

}

<span class="pl-k">func</span> <span class="pl-en">loadDataFromServer</span>() {

}</pre></div>
<ul>
<li>Event action:
(Các hàm sự kiện IBAction, TouchBegin..)</li>
</ul>
<p>Sắp xếp theo thứ tự abc</p>
<div class="highlight highlight-source-swift"><pre><span class="pl-c"><span class="pl-c">//</span>MARK: - Event action</span>
<span class="pl-c"></span><span class="pl-k">@IBAction</span> <span class="pl-k">func</span> <span class="pl-en">buttonQualificationClicked</span>(<span class="pl-smi"><span class="pl-en">sender</span></span>: <span class="pl-c1">AnyObject</span>) {

}

<span class="pl-k">@IBAction</span> <span class="pl-k">func</span> <span class="pl-en">buttonSexClicked</span>(<span class="pl-smi"><span class="pl-en">sender</span></span>: <span class="pl-c1">AnyObject</span>) {

}</pre></div>
<ul>
<li>Delegate, DataSource:
Không để trong class controller, mà tổ chức theo đúng convention, cài đặt các delegate giống như các Extension của class. VD:</li>
</ul>
<div class="highlight highlight-source-swift"><pre><span class="pl-c"><span class="pl-c">//</span> MARK: - UITableViewDelegate</span>
<span class="pl-c"></span><span class="pl-k">extension</span> <span class="pl-en">JSettingViewController</span>: <span class="pl-e">UITableViewDelegate </span>{

<ul>
}</pre></div>
<ul>
<p><li>Cách đặt tên biến và hàm <br>
- Sử dụng quy tắc "Con lạc đà" cho đặt tên biến và hàm <br>
- Format đặt tên biến: Tiền tố class + Tên tiếng Anh có nghĩa. Ví dụ: viewPlayer, imageThumb, labelTitle,... <br>
- Tiền tố class đặt theo rule:
    + Các class có tên ngắn như: UIView, UILabel, UIImage... => thống nhất bỏ UI đi. <br>
    + Các class có tên dài như: UICollectionView, UICollectionViewController, UITableViewHeaderFooterView... => mọi người có thể đặt thế nào cũng được nhưng phải dễ hiểu => gần với tên class gốc. Ví dụ: UICollectionViewController có thể đặt là: collectionVC, collecVC... <br>
- Đối với hàm cần đảm bảo tên hàm không quá dài cũng như thân hàm cần đảm bảo không dài quá 1 trang trong trình duyệt .
</ul>
<p><h1>File Pod</h1></p>
<p>Chia thành từng cụm chức năng, Comment bởi dấu '#', mỗi cụm cách nhau bở một dòng trống. Trong mỗi cụm, sắp xếp theo thứ tự abc, ví dụ:</p>
<pre lang="pod"><code>

#UI
pod 'DynamicBlurView', '1.1.1'
pod 'IQKeyboardManagerSwift', '4.0.5'
pod 'MZFormSheetPresentationController', '2.4.2'


#Services &amp; Network
pod 'Alamofire', '3.5.0'
pod 'Kingfisher', '2.5.1'
pod 'ReachabilitySwift', '2.3.3'

#Database
pod 'SwiftyJSON', '2.3.2'
pod 'RealmSwift', '1.0.2'

#Google API
pod 'Firebase', '3.5.2'
pod 'Google/SignIn', '3.0.3'

#Facebook API
pod 'FBSDKCoreKit', '4.15.1'
pod 'FBSDKLoginKit', '4.15.1'
pod 'FBSDKShareKit', '4.15.1'
</code></pre>
