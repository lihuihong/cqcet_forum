package com.cqcet.controller.show;

import com.cqcet.entity.*;
import com.cqcet.exception.LException;
import com.cqcet.services.*;
import com.cqcet.util.MarkdownUtils;
import com.github.pagehelper.PageInfo;
import com.github.pagehelper.page.PageMethod;
import com.sun.scenario.effect.impl.prism.PrImage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.HtmlUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * Created by 那个谁 on 2018/9/11.
 * 帖子
 */
@Controller
@RequestMapping(value = "/show")
public class ForumController {

    @Autowired
    private ArticleService articleService;
    @Autowired
    private CollegeService collegeService;
    @Autowired
    private UserService userService;
    @Autowired
    private TypeService typeService;
    @Autowired
    private AnswerService answerService;
    @Autowired
    private SensitiveService sensitiveService;
    @Autowired
    private LikeService likeService;
    @Autowired
    FollowService followService;


    /**
     * 查询所有帖子
     *
     * @param map
     * @return
     */
    @RequestMapping("/forum.action")
    public String index(ModelMap map, HttpServletRequest request) throws LException {

        User userInfo = userService.getUserInfo(request);
        if (userInfo == null) {
            return "/show/login";
        }

        List<College> list = collegeService.list();
        List<Forum> forums = new ArrayList<Forum>();
        for (College college : list) {
            Forum forum = articleService.selectByCollege(college);
            forums.add(forum);
        }

        map.put("list", forums);
        return "show/forum";
    }

    /**
     * 根据根据学院id查询信息
     *
     * @return
     */
    @RequestMapping(value = "/answer.action", method = {RequestMethod.GET})
    public String answer(ModelMap map, HttpServletRequest request, @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                         @RequestParam(value = "pageSize", defaultValue = "8") int pageSize,
                         @RequestParam(value = "collegeId") String collegeId,
                         @RequestParam(required = false,value = "subject",defaultValue = "0") String subject) throws LException {

        List<Article> list;
        User userInfo = userService.getUserInfo(request);
        if (userInfo == null) {
            return "/show/login";
        }
        //得到当前用户登录的id
        String userId = userInfo.getId();
        Map<String, Object> param = new HashMap<>();
        if (!(userId.equals(null))) {
            User user = userService.selectById(userId);
            map.put("user", user);
            param.put("userId", userId);
            param.put("status", "0");
            param.put("collegeId", collegeId);
            //帖子
            param.put("alias",subject);
            list = articleService.list(param);
            map.put("userId", userId);
            map.put("articleList", list);
        } else {
            param.put("status", "0");
            param.put("collegeId", collegeId);
            list = articleService.list(param);
            map.put("articleList", list);
        }
        //学院信息
        College college = collegeService.listById(collegeId);
        //pageHelper分页插件
        //在查询之前调用，传入当前页码，以及每一页显示多少条数据
        PageMethod.startPage(pageNum, pageSize);
        //该学院下帖子信息
        List<Article> articles = articleService.articleByCollegeId(collegeId);
        for (Article article : articles) {
            article.setLiked(likeService.getLikeCount(EntityType.ENTITY_ARTIUCLE,article.getId()));
        }
        PageInfo<Article> articlePageInfo = new PageInfo<Article>(articles);
        map.put("college", college);
        map.put("articles", articlePageInfo);
        return "show/answer";
    }

    /**
     * 根据帖子id查询帖子详情
     *
     * @param map
     * @param pageNum
     * @param pageSize
     * @return
     */
    @RequestMapping("/detail.action")
    public String type(ModelMap map, HttpServletRequest request, @RequestParam(value = "id", defaultValue = "") String id,
                       @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                       @RequestParam(value = "pageSize", defaultValue = "4") int pageSize) throws LException {

        User userInfo = userService.getUserInfo(request);
        if (userInfo == null) {
            return "/show/login";
        }
        //该学院下帖子信息详情
        Article article = articleService.selectById(id);
        User user = userService.selectById(String.valueOf(article.getUserId()));
        map.put("user", user);
        Map<String, Object> param = new HashMap<>();
        param.put("userId", article.getUserId());
        param.put("status", "0");
        //该帖子是否获得该用户的赞
        article.setIslike(likeService.getLikeStatus(Integer.parseInt(userInfo.getId()),EntityType.ENTITY_ARTIUCLE,article.getId()));
        //该帖子获得赞的总数
        article.setLiked(likeService.getLikeCount(EntityType.ENTITY_ARTIUCLE,article.getId()));
        String content = article.getContent();
        article.setContent(MarkdownUtils.markdownToHtmlExtensions(content));
        map.put("article", article);
        List<Article> articles = articleService.list(param);
        map.put("articleList",articles);
        //是否关注
        boolean follower = followService.isFollower(Integer.parseInt(userInfo.getId()), EntityType.ENTITY_USER,article.getUserId() );
        map.put("follower",follower);

        List<Answer> answers = answerService.queryAnswerById(Integer.parseInt(id));

        if(answers.size()!=0){
            flag = new boolean[answers.get(answers.size()-1).getId()+1];

            List<Map<String,Object>> list = printf(answers);
        /*for(Map<String,Object> maps : list){
            System.out.println(((User)maps.get("user")).getUsername()+","+maps.get("answer"));

            if(maps.get("child")==null)
                continue;
            List<Map<String,Object>> childs = (List<Map<String,Object>>)maps.get("child");
            for(Map<String,Object> child : childs){
                System.out.println(child.get("answer"));
                //System.out.println("____"+((User)child.get("chiildUser")).getUsername()+"回复了 "+((User)child.get("parentUser")).getUsername()+": "+((Answer)child.get("answer")).getContent());
            }
        }*/

            map.put("answerList",list);
        }


        return "show/detail";
    }

    private boolean[] flag;


    public List<Map<String,Object>> printf(List<Answer> answers){
        List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
        for(Answer child : answers){
            if(flag[child.getId()])
                continue;
            flag[child.getId()] = true;
            Map<String,Object> map = new HashMap<>();
            User user = userService.selectById(String.valueOf(child.getUserId()));
            map.put("user",user);
            map.put("answer",child);
            //map.put("num",0);

            if(child.getChildId()!=null){
                List<Map<String,Object>> childs = new ArrayList<Map<String,Object>>();
                printf(childs,answers,1,child);
                map.put("child",childs);
            }

            //System.out.println(a.toString());

            list.add(map);
        }
        return list;
    }

    public void printf(List<Map<String,Object>> list,List<Answer> answers,int i,Answer child){

        for(Answer a : answers){
            if(flag[a.getId()])
                continue;
            if(a.getParentId() == child.getChildId()){
                //System.out.println(get(i) + a.toString());
                Map<String,Object> map = new HashMap<>();
                User parentUser = userService.selectById(String.valueOf(child.getUserId()));
                User chiildUser = userService.selectById(String.valueOf(a.getUserId()));
                map.put("parentUser",parentUser);
                map.put("childUser",chiildUser);
                map.put("answer",a);
                //map.put("num",i);
                list.add(map);
                flag[a.getId()] = true;
                if(a.getChildId() != null){
                    printf(list,answers,i+1,a);
                }
                printf(list,answers,i,child);
            }
        }
    }

    public String get(int n){
        String line = "";
        for(int i = 0;i < n;i++)
            line += "-";
        return line;
    }


    /**
     * 根据用户id查询用户全部帖子
     *
     * @param map
     * @param pageNum
     * @param pageSize
     * @return
     */
    @RequestMapping("/personArticle.action")
    public String personArticle(ModelMap map, HttpServletRequest request, @RequestParam(value = "id", defaultValue = "") String id,
                                @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                                @RequestParam(value = "pageSize", defaultValue = "8") int pageSize) {

        User userInfo = userService.getUserInfo(request);
        if (userInfo == null) {
            return "/show/login";
        }
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("userId", id);
        param.put("status", 0);

        List<Article> articles = articleService.list(param);
        List<List> allTypes = new ArrayList<>();
        Set<String> set = new HashSet<>();
        for (Article article : articles) {
            List<Object> types = new ArrayList();
            //根据所有帖子分类id查询所有帖子分类类型
            Type type = typeService.articleTypeByTypeId(String.valueOf(article.getTypeId()));
            //根据typeId查询帖子总数
            int count = articleService.countByTypeId(type.getId(), id, "0");
            //去掉重复的帖子分类名
            if (!(set.contains(type.getName()))) {
                types.add(type);
                types.add(count);
                allTypes.add(types);
                set.add(type.getName());
            }
        }
        // pageHelper分页插件
        // 只需要在查询之前调用，传入当前页码，以及每一页显示多少条
        PageMethod.startPage(pageNum, pageSize);
        List<Article> list = articleService.list(param);
        //添加点赞数
        for (Article article : list) {
            article.setLiked(likeService.getLikeCount(EntityType.ENTITY_ARTIUCLE,article.getId()));
        }
        PageInfo<Article> pageInfo = new PageInfo<Article>(list);
        map.put("pageInfo", pageInfo);
        User user = userService.selectById(id);
        map.put("user", user);
        //List<Type> types = typeService.list();

        // 查询所有帖子分类
        map.put("typeList", allTypes);

        return "show/personArticle";
    }

    /**
     * 根据帖子分类id查询用户帖子
     *
     * @param map
     * @param pageNum
     * @param pageSize
     * @return
     */
    @RequestMapping("/article_type.action")
    public String articleType(ModelMap map, HttpServletRequest request, @RequestParam(value = "id", defaultValue = "") String id,
                              @RequestParam(value = "typeId", defaultValue = "") String typeId,
                              @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                              @RequestParam(value = "pageSize", defaultValue = "8") int pageSize) {

        User userInfo = userService.getUserInfo(request);
        if (userInfo == null) {
            return "/show/login";
        }
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("userId",id);
        param.put("status", 0);

        List<Article> articles = articleService.list(param);
        List<List> allTypes = new ArrayList<>();
        Set<String> set = new HashSet<>();
        for (Article article : articles) {
            List<Object> types = new ArrayList();
            //根据所有帖子分类id查询所有帖子分类类型
            Type type = typeService.articleTypeByTypeId(String.valueOf(article.getTypeId()));
            //根据typeId查询帖子总数
            int count = articleService.countByTypeId(type.getId(), id, "0");
            //去掉重复的帖子分类名
            if (!(set.contains(type.getName()))) {
                types.add(type);
                types.add(count);
                allTypes.add(types);
                set.add(type.getName());
            }
        }
        map.put("typeName", typeService.articleTypeByTypeId(typeId).getName());
        Map<String, Object> param1 = new HashMap<String, Object>();
        param1.put("typeId",typeId);
        param1.put("userId",id);
        param1.put("status", 0);
        // pageHelper分页插件
        // 只需要在查询之前调用，传入当前页码，以及每一页显示多少条
        PageMethod.startPage(pageNum, pageSize);
        List<Article> list = articleService.list(param1);

        PageInfo<Article> pageInfo = new PageInfo<Article>(list);
        map.put("pageInfo", pageInfo);
        User user = userService.selectById(id);
        map.put("user", user);
        //List<Type> types = typeService.list();
        // 查询所有帖子分类
        map.put("typeList", allTypes);
        return "show/type";
    }

    /**
     * 根据关键字搜索帖子
     *
     * @param map
     * @param pageNum
     * @param pageSize
     * @return
     */
    @RequestMapping("/search.action")
    public String search(ModelMap map,@RequestParam(required = false,value = "keyWord")String keyWord,
                         @RequestParam(required = false, value = "type") String typeName,
                         @RequestParam(value = "pageNum",defaultValue = "1")int pageNum,
                         @RequestParam(value = "pageSize",defaultValue = "6")int pageSize){

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("status", 0);
        map.put("name",typeName);
        map.put("articleList",articleService.list(null));

        // 查询所有帖子分类以及该分类下条数
        List<List> lists = new ArrayList<>();
        List<Type> types = typeService.list();
        for (Type type : types) {
            List<Object> typeList = new ArrayList<>();
            int countByTypeId = articleService.countByTypeId(type.getId(), null, "0");
            typeList.add(countByTypeId);
            typeList.add(type);
            lists.add(typeList);
        }

        map.put("typeList", lists);
        if ("用户".equals(typeName)){
            param.put("username","%" + keyWord.trim() + "%");
            List<User> userList = userService.usernameList("%" + keyWord.trim() + "%");
            map.put("keyWord", keyWord);
            map.put("userlist", userList);
            return "show/search_user";
        }

        if ("帖子".equals(typeName)){

            param.put("keyWord", "%" + keyWord.trim() + "%");

            // pageHelper分页插件
            // 只需要在查询之前调用，传入当前页码，以及每一页显示多少条
            PageMethod.startPage(pageNum, pageSize);
            List<Article> list = articleService.list(param);
            PageInfo<Article> pageInfo = new PageInfo<Article>(list);
            //System.out.println(pageInfo.getList().size());
            map.put("pageInfo", pageInfo);
            return "show/search_article";
        }else {
            param.put("userlist", userService.list_article());
        }

        return "show/search";
    }

    /**
     * 应用中心
     * @param map
     * @param pageNum
     * @param pageSize
     * @return
     */
    @RequestMapping("/app.action")
    public String app(ModelMap map,
                         @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
                         @RequestParam(value = "pageSize", defaultValue = "4") int pageSize) {

        return "show/app";
    }

    /**
     * 发布帖子
     *
     * @param map
     * @return
     */
    @RequestMapping("/posted.action")
    public String posted(ModelMap map,
                         HttpServletRequest request,
                         @RequestParam(required = false, value = "id") String id) throws LException {

        User userInfo = userService.getUserInfo(request);
        if (userInfo == null) {
            return "/show/login";
        }
        // 单个文章的信息
        if (!StringUtils.isEmpty(id)) {
            Article article = articleService.selectById(id);
            map.put("article", article);
        }
        List<Type> list = typeService.list();
        map.put("typeList", list);
        return "show/posted";
    }

    /**
     * 帖子保存
     *
     * @return
     */
    @RequestMapping(value = "/save_article.json", method = {RequestMethod.POST})
    @ResponseBody
    public Result save(HttpServletRequest request, @RequestParam(value = "stem") String stem,
                       @RequestParam(value = "title") String title,
                       @RequestParam(value = "type") String type,
                       @RequestParam(value = "id") String id,
                       @RequestParam(value = "cover") String cover) throws LException {
        //得到当前用户登录的id
        User userInfo = userService.getUserInfo(request);
        if (userInfo == null) {
            throw new LException("未登录");
        }
        // 校验标题长度
        if (title.length()>80) {
            throw new LException("标题超过了80个");
        }
        Article article = new Article();
        //article.setContent(HtmlUtils.htmlEscape(stem.replaceAll("(\r\n|\n)", "<br/>")));
        article.setTitle(HtmlUtils.htmlEscape(title));
        article.setCover(cover);
        article.setTitle(sensitiveService.filter(title));
        article.setContent(sensitiveService.filter(stem));
        article.setUserId(Integer.valueOf(userInfo.getId()));
        //判断帖子id
        if (id != ""){
            article.setId(Integer.valueOf(id));
        }
        Type typeName = typeService.articleTypeByTypeId(type);
        article.setCollegeId(userInfo.getCollege());
        article.setTypeId(Integer.valueOf(typeName.getId()));
        articleService.save(article);
        return Result.success();
    }

    /**
     * 删除帖子
     *
     * @return
     */
    @RequestMapping("/delete.json")
    @ResponseBody
    public Result delete(
            @RequestParam(value = "articleId") String[] articleId) {

        articleService.batchDelete(articleId);

        return Result.success();
    }

}
